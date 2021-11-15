# Приложение, в котором пользователь может составить свой личный словарь незнакомых иностранных слов.

Пользователь вводит слово, слово добавляется в его персональный словарь и к слову подгружается перевод (напр., с API Яндекс Переводчика).

Пользователю выводятся все добавленные слова с переводами в виде списка.

Реализовать минимум 3 языка с возможностью менять направление перевода.

Пользователь может найти ранее добавленное слово в своем словаре используя функцию поиска по слову или по его переводу.

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

__Общий вид архитектуры решения__. Оно имеет вид логического дерева фичей (feature tree):

![alt text](pers-dict-arch.png "")

Серым обозначены фичи без view, зеленым - "большие фичи", реализующие целый экран приложения, голубым - отдельные фичи, имеющие view, которые можно вкладывать в другие фичи.

`B` - Builder, `G` - граф, `R` - роутер, `VC` - ViewController, `MVVM` - паттерн для UI, `D` - domain.  

Реализована слабая связанность экранов друг с другом. Код экранов расположен в папке `UI/BigFeature` в соответствующих каждому экрану папках. За переходы между экранами отвечает `Router`, за инстанцирование фичей с их зависимостями отвечает `Builder`. 

Большое внимание уделено внедрению зависимостей, использованию протоколов и слабой связанности кода приложения.

Для того, чтобы выполнять "тяжелые" IO-операции и вычисления в бэкграунде, используется стандартный GCD.

Папка `Repository` - реализация локального хранения слов. За протоколом скрыта реализация на фреймворке Core Data.

Папка `Service` - получение данных из внешнего сетевого API. Использован API онлайн-словаря PONS.

Раздел `Core` - базовые типы и функциональность приложения.

Приложение локализовано на 2 языка (__английский__ и __русский__).

Для внешних зависимостей использован CocoaPods.

### Некоторые трудности при реализации проекта

Используемое API переводчика (по крайней мере, в бесплатной версии) имеет довольно сильные ограничения на частоту запросов, поэтому "живой" поиск слов и переводов не реализован.

API Яндекс Переводчика не использовалось в силу его платности.
