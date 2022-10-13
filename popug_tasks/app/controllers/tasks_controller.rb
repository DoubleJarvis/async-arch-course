class TasksController < ApplicationController
  def index
    @tasks = Task.where(status: :started)
    @tasks = @tasks.where(account_id: current_account.id) if current_account.employee?
  end

  def create
    @task = Task.new(task_params)
    @task.account = Account.employee.random
    @task.cost =   rand(10..20) * 100 * -1 # cents
    @task.reward = rand(20..40) * 100

    if @task.save
      flash.notice = "Task created"

      # TODO PRODUCE: CUD TaskCreated tasks_stream
    else
      flash.alert = "Task not created #{@task.errors.full_messages.to_sentence}"
    end
    
    redirect_to tasks_path
  end

  def finish
    @task = current_account.tasks.find(params[:id])

    @task.update(status: :finished)

    # TODO PRODUCE: BE TaskFinished 

    redirect_to tasks_path
  end

  def reassign
    @tasks = Task.started

    @tasks.each(&:reassign)

    # TODO PRODUCE: BE TaskAssigned / TasksAssigned(multiple?)

    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:description)
  end
end
