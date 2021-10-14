# Тестовое задание

Взято из Podlodka, ссылка: https://www.youtube.com/watch?v=ZD7Jr-Gy36M.

## Задача

Разработать приложение, в котором пользователь может составить свой личный словарь незнакомых иностранных слов.

## Первая реализация

Пользователь вводит слово, слово добавляется в его персональный словарь и к слову подгружается перевод (напр., с API Яндекс Переводчика).

Пользователю выводятся все добавленные слова с переводами в виде списка.

Поиск происходит по нажатию на клавиатуре "Ok" (??).

Реализовать минимум 3 языка с возможностью менять направление перевода.

Пользователь может найти ранее добавленное слово в своем словаре используя функцию поиска по слову или по его переводу.

## Вторая реализация (++)

Поиск происходит как только пользователь вводит текст (живой поиск, задержка менее 500 мс).

Добавление слов в Избранное. Это отдельный экран. Слова можно удалять из Избранного.

В общем списке избранные слова помечаются звездочкой.

### Используемые технологии.

UI: UIKit, вёрстка из кода.

Архитектура на выбор: MVVM, Redux, RIBs.

Юнит-тесты.

Способ работы с сетью и базу данных выбрать на свое усмотрение.

---

# Замечания о решении задания.

Для корректной работы приложения следует получить ключ от PONS Online Dictionary API https://ru.pons.com/p/onlajn-slovar/developers/api и задать его в поле `secret` объекта `ponsApiData` (см. код приложения).

API словаря может поддерживать не все направления перевода. Например, переводить с английского на русский или на итальянский, но не переводить с итальянского на русский.

## Общие сведения о решении

В приложении реализованы три экрана:

* экран с главным списком слов
* экран добавления нового слова (чтобы добавить, надо нажать кнопку ОК)
* отдельный экран поиска по словам.

Реализована слабая связанность экранов друг с другом. Код экранов расположен в папке `UI` в соответствующих каждому экрану папках. Для реализации экранов использован паттерн MVVM. За переходы между экранами отвечает `Router`, за инстанцирование MVVM'ов с их зависимостями отвечает `Builder`. 

Большое внимание уделено внедрению зависимостей, использованию протоколов и слабой связанности кода приложения.

Для того, чтобы выполнять "тяжелые" IO-операции и вычисления в бэкграунде, используется стандартный GCD.

Папка `Repository` - реализация локального хранения слов. За протоколом скрыта реализация на фреймворке Core Data.

Папка `Service` - получение данных из внешнего сетевого API. Использован API онлайн-словаря PONS.

Раздел `Core` - базовые типы и функциональность приложения.

Приложение локализовано на 2 языка (__английский__ и __русский__).

Для бизнес-логики экрана добавления нового слова написаны юнит-тесты. Генерация моков - библиотека Cuckoo.

Для внешних зависимостей использован CocoaPods.

