# HW_2

## DiffableDataSource, Delegate, Closures

Сделать приложение - личный дневник "Момента". 

## Функциональные требования: 

1) Экран с "Личными постами": 
  * Это таблица с постами где пост может содержать 1/2/3/4 картинки и текст. Текст может быть сколько угодно большим. Но на главном экране текст максимум в 5 строк и дальше обрезается. Отображается максимум 2 картинки.
  
2) Детальный экран поста: 
  * Любой пост можно нажать и откроется детальный экран с большей информацией, размернутым текстом и фото. Можно отредактировать пост и нажать "Сохранить". Тогда данные обнавляются как на детальном экране, так и на первом экране с "Моментами". Можно удалить пост. Тогда спрашивается подтверждение и пост удаляется, а пользователя возвращает на главный экран с постами. 
  
3) Экран создания поста: 
  * Позволяет добавить текст произвольной длины и изображения из галареии. 

## Технические требования 

 * Экран с "Личными постами": 
    * DiffableDataSource для таблицы с постами.
    * Ячейка с поcтом включает в себя Дату(UILabel), Текст(UILabel), Фотки(UICollectionView). Текст и фотки опциональные, если есть одно из них. В посте должен быть или текст или фотка, просто пустым быть не может. 
    * Дата - это дата на момент создания поста используя Date() и DateFormatter для форматирования типа "13/05/2015 10:15".
    * Текст - это UILabel с макс.кол-вом линий 5. Если текста больше, текст обрезается тремя точками в конце (...).
    * Изображения отображаются горизонтальной сеткой где либо 1 либо 2 друг за другом (слева/справа) вмещается внутрь ячейки. Если изображений больше, то показать только два первых изображения. 
    * В UINavigationBar добавить кнопку UINavigationBar "Добавить" или "+", при нажатии на которую откроется экран создания поста.  
    
    
 * Детальный экран поста: 
   * UIScrollView с компонентами поста в нем. 
   * Текст разворачивается полностью во весь размер.
   * Изображения отображаются сеткой: 1 изображение - одно по центру, 2 изображения - слева/справа, 3 изображения - 2 сверху(слева/справа) и одно снизу по середине занимая всю ширину пропорционально верхним изображениям. 
   * Сверху в UINavigationBar добавить UIBarButtonItem с кнопкой "Редактировать". При нажатии открыть экран редактирования (тот же самый что для создания). 
   
 * Экран создания поста: 
   * UITextView для текста 
   * UICollectionView для изображений. Должна быть возможность удалить добавленное изображение. Для добавления изображений использовать UIImagePickerController. Поставить ограничение на добавление макс 4 изображения. Можно изначально добавить в коллекцию ячейку с изображением типа "+". При нажатии на нее инициировать открытие галерии устройства. 
   * В UINavigationBar добавить кнопку UINavigationBar "Сохранить". При нажатии либо создается новый пост с текущей датой, либо обновляется существующий пост.
   * В UINavigationBar добавить кнопку UINavigationBar "Отмена". При нажатии экран закрывается.   

Переход между экранами с постами и детальным экраном - это push переход через UINavigationController.  
Переход на экран создания поста - это modal переход.
Обновлять данные между списком и детальным экране нужно используя Delegate.
Обновлять данные между созданием поста и любым экраном который его вызвал - используя кложур, который возвращает готовый/обновленный пост. 
 
 ### Общие рекомендации 
 
 * Пишем чистый код, с полными названиями переменных/методов/классов. 
 * Не коммитим закоменченный код. 
 * При работе с UI используем UIStackView где возможно.
