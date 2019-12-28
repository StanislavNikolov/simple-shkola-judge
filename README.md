```
Система за проверка на задачи по информатика.
Може да се настрои за минута, достатъчно кратка и проста да бъде прочетена и разбрана за под 10 минути.

Основна файлова структура:
judge root:
  * problems/
    * task1/ - име на задачата, трябва да е същото в index.html
      * statement.html - условие, което хората виждат от основният интерфейс
      * tests/
        * 01.in - първи тестов пример (вход)
        * 01.sol - първи тестов пример (изход)
        ....
    ....

  * solutions/
    * username/ - името на потребителя
      * taskname.cpp - решението на задача taskname за потребител username
      ...
    ...

  * results/ - папка със log-овете на output-ите от компилатора и оценятора
    * username/ - името на потребителя
      * taskname.html - какво е видял потребителя като е пратил задачата
      ....
    ....

  * server.js - http - сервира index.html и условията. Поема решенията и ги дава на wrapper.sh
  * wrapper.sh - компилира решение и вика fchecker.sh
  * fchecker.sh - оценява решението
  * index.html - Основният interface. Дава списъкът на задачи. Иска html на условието от сървъра.
```
# setup
```bash
git clone https://github.com/StanislavNikolov/simple-shkola-judge judge
cd judge
npm install
node server.js
```
