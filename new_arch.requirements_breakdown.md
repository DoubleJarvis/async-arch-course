# Разбор требований на события
## Таск трекер
### Авторизация
Actor: Account
Command: Login into Task Tracker
Data: ???
Event: Account.LoggedIn

### Создание тасок
Actor: Account
Command: Create new Task
Data: Task
Event: Tasks.Created

### Выполнение таски
Actor: Account
Command: Mark task as finished
Data: Task
Event: Tasks.Finished

### Рандомный ассайн открытых задач
Actor: Account(admin, manager)
Command: Reassign all tasks
Data: Task + (НовыйВладелец)Account.public_id
Event: Tasks.Assigned

## Accounting
### Отбор денег за таску у попуга
Actor: Tasks.Assigned
Command: Take task cost from popug
Data: Task.cost, Account.public_id
Event: Accounting.MoneyTaken

### Даем денег за выполненную таску попугу
Actor: Tasks.Finished
Command: Give award to popug
Data: Task.award, Account.public_id
Event: Acounting.MoneyGiven

### В конце дня высылаем зарплату
Actor: Cronjob
Command: Send payment
Data: Account.balance
Event: Accounting.PaymentSent
