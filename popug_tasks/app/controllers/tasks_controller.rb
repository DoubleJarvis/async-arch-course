class TasksController < ApplicationController
  def index
    @tasks = Task.where(status: :started)
    @tasks = @tasks.where(account_id: current_account.id) if current_account&.employee?

    @tasks = [] unless current_account
  end

  def create
    @task = Task.new(task_params)
    @task.account = Account.employee.random
    @task.cost    = rand(10..20) * 100 * -1 # cents
    @task.reward  = rand(20..40) * 100

    if @task.save
      flash.notice = "Task created"

      event = {
        **shared_event_data,
        event_name: 'TaskCreated',
        data: @task.event_data
      }

      result = SchemaRegistry.validate_event(event, 'tasks.created', version: 1)
      if result.success?
        KAFKA_PRODUCER.produce_sync(payload: event.to_json, topic: 'tasks-stream')
      else
        # Sentry.notify("Cannot produce AccountCreated #{result.failure.to_json}")
      end
    else
      flash.alert = "Task not created #{@task.errors.full_messages.to_sentence}"
    end
    
    redirect_to tasks_path
  end

  def finish
    @task = current_account.tasks.find(params[:id])

    @task.update(status: :finished)

    event = {
      **shared_event_data,
      event_name: 'TaskFinished',
      data: { public_id: @task.public_id }
    }

    result = SchemaRegistry.validate_event(event, 'tasks.finished', version: 1)
    if result.success?
      KAFKA_PRODUCER.produce_sync(payload: event.to_json, topic: 'tasks')
    else
      # Sentry.notify("Cannot produce AccountCreated #{result.failure.to_json}")
    end

    redirect_to tasks_path
  end

  def reassign
    @tasks = Task.started

    @tasks.each(&:reassign)

    @tasks.each do |task|
      event = {
        **shared_event_data,
        event_name: 'TaskAssigned',
        data: { public_id: task.public_id, account_public_id: task.account.public_id }
      }

      result = SchemaRegistry.validate_event(event, 'tasks.assigned', version: 1)

      if result.success?
        KAFKA_PRODUCER.produce_sync(payload: event.to_json, topic: 'tasks')
      else
        # Sentry.notify("Cannot produce AccountCreated #{result.failure.to_json}")
      end
  
    end

    flash.notice = "Unfinished tasks reassigned"

    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:description)
  end

  def shared_event_data
    {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'popug_tasks',
    }
  end
end
