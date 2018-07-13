#Использовать notify
#Использовать asserts
#Использовать logos
#Использовать tempfiles
#Использовать reflector
#Использовать fluent

Перем ЧтениеПараметровВыполнено; // булево - флаг, что чтение выполнено

Перем ИндексПараметров; // Класс ИндексЗначений - плоский индекс всех параметров
Перем ПрочитанныеПараметры; // Соответствие - результат чтения из провайдеров

Перем КлассПараметров; // Произвольный класс обеспечивающий: Функция Параметры() Экспорт, Процедура УстановитьПараметры(НовыеПараметры) Экспорт

Перем ПровайдерыПараметров; // Соответствие

Перем НастройкаФайловогоПровайдера; // Класс НастройкиФайловогоПровайдера

Перем ИнтерфейсПриемника; // Класс ИнтерфейсОбъекта

Перем ВнутреннийКонструкторПараметров; // Класс КонструкторПараметров
Перем ИспользуетсяКонструкторПараметров; // булево

Перем Лог; // Логгер

#Область Экспортных_процедур

// Получает и возвращает значение из индекса параметров
//
// Параметры:
//   ИмяПараметра        - Строка - имя параметра
//                                  допустимо указание пути к параметру через точку (например, "config.server.protocol")
//   ЗначениеПоУмолчанию - Произвольный - возвращаемое значение в случае отсутствия параметра после чтения
//
// Возвращаемое значение:
//   Строка, Число, Булево, Массив, Соответствие, Неопределено - значение параметра
//
Функция Параметр(Знач ИмяПараметра, Знач ЗначениеПоУмолчанию = Неопределено) Экспорт

	ЗначениеИзИндекса = ИндексПараметров.Значение(ИмяПараметра);

	Если НЕ ЗначениеИзИндекса = Неопределено Тогда
		Возврат ЗначениеИзИндекса;
	КонецЕсли;

	Возврат ЗначениеПоУмолчанию;

КонецФункции

// Возвращает признак выполнения чтения параметров
//
// Возвращаемое значение:
//   Булево - признак выполнения чтения параметров
//
Функция ЧтениеВыполнено() Экспорт
	Возврат ЧтениеПараметровВыполнено;
КонецФункции

// Выполняет чтения параметров из доступных провайдеров
//
Процедура Прочитать() Экспорт

	ИндексПараметров.Очистить();
	ПрочитанныеПараметры.Очистить();
	ВыполнитьЧтениеПровайдеров();

	Лог.Отладка("ПрочитанныеПараметры количество <%1>", ПрочитанныеПараметры.Количество());

	Если ИспользуетсяКонструкторПараметров Тогда

		ВнутреннийКонструкторПараметров.ИзСоответствия(ПрочитанныеПараметры);

		ПараметрыДляИндекса = ВнутреннийКонструкторПараметров.ВСоответствие();

		Лог.Отладка("Попытка выгрузки в класс <%1>", КлассПараметров);
	
		Если Не КлассПараметров = Неопределено Тогда
			ВыгрузитьПараметрыВКлассПриемник();
		КонецЕсли;

	Иначе
		ПараметрыДляИндекса = ПрочитанныеПараметры;
	КонецЕсли;

	ПоказатьНастройкиВРежимеОтладки(ПараметрыДляИндекса);

	ИндексПараметров.Коллекция(ПараметрыДляИндекса);

	ЧтениеПараметровВыполнено = ПараметрыДляИндекса.Количество() > 0;

КонецПроцедуры

// Устанавливает путь к файлу параметров
//
// Параметры:
//   ПутьКФайлу - Строка - полный путь к файлу параметров
//
Процедура УстановитьФайлПараметров(Знач ПутьКФайлу) Экспорт

	НастройкаФайловогоПровайдера = ПолучитьНастройкуФайловогоПровайдера();

	НастройкаФайловогоПровайдера.УстановитьФайлПараметров(ПутьКФайлу);

КонецПроцедуры

// Добавляет в таблицу провайдеров произвольный класс-провайдер
//
// Параметры:
//   КлассОбъект             - Объект - класс провайдера или имя класса
//   Приоритет               - Число        - Числовой приоритет выполнения провайдеры (по умолчанию 99)
//
Процедура ДобавитьПровайдерПараметров(Знач КлассОбъект,
									Знач Приоритет = Неопределено) Экспорт

	ДобавляемыйПровайдерПараметров = Новый ПровайдерПараметров(КлассОбъект);

	Если Не Приоритет = Неопределено Тогда
		ДобавляемыйПровайдерПараметров.УстановитьПриоритет(Приоритет);
	КонецЕсли;

	ПровайдерыПараметров.Вставить(ДобавляемыйПровайдерПараметров.Идентификатор, ДобавляемыйПровайдерПараметров);

КонецПроцедуры

// Отключает провайдера из таблицы провайдеров
//
// Параметры:
//   ИдентификаторПровайдера - Строка - короткий идентификатор провайдера (например, json)
//
Процедура ОтключитьПровайдер(Знач ИдентификаторПровайдера) Экспорт

	Провайдер = ПровайдерыПараметров[ИдентификаторПровайдера];

	Если Провайдер = Неопределено Тогда
		Лог.Отладка("Провайдер с идентификатором <%1> не найден", ИдентификаторПровайдера);
		Возврат;
	КонецЕсли;

	Провайдер.Отключить();

КонецПроцедуры

// Возвращает объект настройки поиска файлов
//
//  Возвращаемое значение:
//   Объект.НастройкаФайловогоПровайдера - внутренний класс по настройке файловых провайдеров
//
Функция НастройкаПоискаФайла() Экспорт
	Возврат ПолучитьНастройкуФайловогоПровайдера();
КонецФункции

// Добавляет и включает встроенный провайдер JSON
//
// Параметры:
//   Приоритет - Число - Числовой приоритет выполнения провайдеры (по умолчанию 0)
//
Процедура ИспользоватьПровайдерJSON(Знач Приоритет = 0) Экспорт

	ДобавитьПровайдерПараметров(Новый ПровайдерПараметровJSON, Приоритет);

КонецПроцедуры

// Добавляет и включает встроенный провайдер YAML
//
// Параметры:
//   Приоритет - Число - Числовой приоритет выполнения провайдеры (по умолчанию 0)
//
Процедура ИспользоватьПровайдерYAML(Знач Приоритет = 0) Экспорт

	ДобавитьПровайдерПараметров(Новый ПровайдерПараметровYAML, Приоритет);

КонецПроцедуры

// Производит автоматическую настройку провайдеров
//
// Параметры:
//   НаименованиеФайла - Строка - Наименование файла параметров
//   ВложенныйПодкаталог - Строка - Дополнительный каталог, для стандартных путей
//   ИдентификаторыПровайдеров - Строка - Идентификаторы встроенных параметров, по умолчанию <yaml json>
//
Процедура АвтоНастройка(Знач НаименованиеФайла,
	Знач ВложенныйПодкаталог = Неопределено,
	Знач ИдентификаторыПровайдеров = "yaml json") Экспорт

	НастройкаФайловогоПровайдера = ПолучитьНастройкуФайловогоПровайдера();

	НастройкаФайловогоПровайдера.УстановитьИмяФайла(НаименованиеФайла);
	НастройкаФайловогоПровайдера.УстановитьСтандартныеКаталогиПоиска(ВложенныйПодкаталог);

	МассивИдентификаторовПровайдеров = СтрРазделить(Врег(ИдентификаторыПровайдеров), " ");

	ПровайдерYAML = МассивИдентификаторовПровайдеров.Найти("YAML");
	Если НЕ ПровайдерYAML = Неопределено Тогда
		ИспользоватьПровайдерYAML(ПровайдерYAML);
	КонецЕсли;

	ПровайдерJSON = МассивИдентификаторовПровайдеров.Найти("JSON");
	Если НЕ ПровайдерJSON = Неопределено Тогда
		ИспользоватьПровайдерJSON(ПровайдерJSON);
	КонецЕсли;

КонецПроцедуры

// Устанавливает класс параметров для описания конструктора параметров и установки результатов чтения
//
// Параметры:
//   КлассОбъект - Объект - произвольный класс, реализующий ряд экспортных процедур
//
Процедура УстановитьКлассПараметров(КлассОбъект) Экспорт

	Если Не ИспользуетсяКонструкторПараметров Тогда
		Возврат;
	КонецЕсли;

	КлассПараметров = КлассОбъект;

	ИнтерфейсРеализован(ИнтерфейсПриемника, КлассОбъект, Истина);

	ВнутреннийКонструкторПараметров.ИзКласса(КлассОбъект);

КонецПроцедуры

// Создает, определяет и возвращает новый внутренний конструктор параметров
//
// Параметры:
//   КлассОбъект - Объект - Класс объект реализующий интерфейс конструктора параметров
//
// Возвращаемое значение:
//   Объект.КонструкторПараметров - ссылка на новый элемент класса <КонструкторПараметров>
//
Функция КонструкторПараметров(КлассОбъект = Неопределено) Экспорт

	Если ВнутреннийКонструкторПараметров = Неопределено Тогда

		ВнутреннийКонструкторПараметров = ПолучитьКонструкторПараметров();
	
	КонецЕсли;
	
	ИспользуетсяКонструкторПараметров = Истина;

	Если ЗначениеЗаполнено(КлассОбъект)
		И ИнтерфейсРеализован(ИнтерфейсПриемника, КлассОбъект, Истина) Тогда

		УстановитьКлассПараметров(КлассОбъект);

	КонецЕсли;

	Возврат ВнутреннийКонструкторПараметров;

КонецФункции

// Создает и возвращает новый конструктор параметров
//
// Параметры:
//   КлассОбъект - Объект - Класс объект реализующий интерфейс конструктора параметров
//
// Возвращаемое значение:
//   Объект.КонструкторПараметров - ссылка на новый элемент класса <КонструкторПараметров>
//
Функция НовыйКонструкторПараметров(КлассОбъект = Неопределено) Экспорт

	ВнутреннийКонструкторПараметров = КонструкторПараметров();
	КонструкторПараметров = ВнутреннийКонструкторПараметров.НовыеПараметры();

	Если ЗначениеЗаполнено(КлассОбъект) Тогда

		КонструкторПараметров.ИзКласса(КлассОбъект);

	КонецЕсли;

	Возврат КонструкторПараметров;

КонецФункции

#КонецОбласти

#Область Вспомогательные_процедуры_и_функции

Функция ПолучитьКонструкторПараметров()

	Конструктор = Новый КонструкторПараметров();

	Возврат Конструктор;

КонецФункции

Процедура ВыполнитьЧтениеПровайдеров()

	КоллекцияПровайдеров = Новый ПроцессорКоллекций;
	КоллекцияПровайдеров.УстановитьКоллекцию(ПровайдерыПараметров);

	КоличествоПровайдеров = КоллекцияПровайдеров
			.Сортировать("Результат = Элемент1.Значение.Приоритет > Элемент2.Значение.Приоритет")
			.Фильтровать("Результат = Элемент.Значение.Включен")
			.Количество();

	Если КоличествоПровайдеров = 0 Тогда
		Возврат;
	Иначе

		ПроцедураЧтенияПровайдера = Новый ОписаниеОповещения("ОбработчикВыполненияЧтениеПровайдера", ЭтотОбъект);
		КоллекцияПровайдеров.ДляКаждого(ПроцедураЧтенияПровайдера);

	КонецЕсли;

КонецПроцедуры

// Обработчик выполнения чтения провайдера
//
// Параметры:
//   Результат - КлючЗначение - Элемент индекса провайдеров
//   ДополнительныеПараметры - Структура - дополнительная структура
//
Процедура ОбработчикВыполненияЧтениеПровайдера(Результат, ДополнительныеПараметры) Экспорт

	Провайдер = ДополнительныеПараметры.Элемент.Значение;

	ВыполнитьЧтениеДляПровайдера(Провайдер);

КонецПроцедуры

Процедура ВыполнитьЧтениеДляПровайдера(КлассПровайдера)

	ИдентификаторПровайдера = КлассПровайдера.Идентификатор;

	ПараметрыПровайдера = Новый Структура;
	Если КлассПровайдера.ЭтоФайловыйПровайдер() Тогда
		ПараметрыПровайдера = ПолучитьНастройкуФайловогоПровайдера().ПолучитьНастройки();
	КонецЕсли;

	Попытка
		ПрочитанныеПараметрыПровайдера = КлассПровайдера.ПрочитатьПараметры(ПараметрыПровайдера);
	Исключение
		Лог.КритичнаяОшибка("Не удалось прочитать параметры используя провайдер <%1>. По причине: %2",
							ИдентификаторПровайдера,
							ОписаниеОшибки());
		Возврат;
	КонецПопытки;

	Лог.Отладка("Провайдер <%1> вернул количество параметров <%2>",
				ИдентификаторПровайдера,
				ПрочитанныеПараметрыПровайдера.Количество());

	ОбъединитьПрочитанныеПараметры(ПрочитанныеПараметрыПровайдера, ПрочитанныеПараметры);

КонецПроцедуры

Процедура ОбъединитьПрочитанныеПараметры(Источник, Приемник)

	Для каждого КлючЗначение Из Источник Цикл

		КлючИсточника = КлючЗначение.Ключ;
		ЗначениеИсточника = КлючЗначение.Значение;

		ЗначениеПриемника = Приемник[КлючИсточника];

		Если ЗначениеПриемника = Неопределено Тогда
			Приемник.Вставить(КлючИсточника, ЗначениеИсточника);
			Продолжить;
		КонецЕсли;

		Если Не ТипЗнч(ЗначениеИсточника) = ТипЗнч(ЗначениеПриемника) Тогда
			Продолжить;
		КонецЕсли;

		Если ТипЗнч(ЗначениеИсточника) = Тип("Соответствие") Тогда

			ОбъединитьПрочитанныеПараметры(ЗначениеИсточника, ЗначениеПриемника);

		ИначеЕсли ТипЗнч(ЗначениеИсточника) = Тип("Массив") Тогда

			Для каждого ЭлементМассива Из ЗначениеИсточника Цикл

				Если ТипЗнч(ЭлементМассива) = Тип("Строка") Тогда

					НайденныйЭлемент = ЗначениеПриемника.Найти(ЭлементМассива);

					Если НайденныйЭлемент = Неопределено Тогда
						ЗначениеПриемника.Добавить(ЭлементМассива);
						Продолжить;
					КонецЕсли;

				КонецЕсли;

				ЗначениеПриемника.Добавить(ЭлементМассива);

			КонецЦикла;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Процедура ВыгрузитьПараметрыВКлассПриемник()

	СтруктураПараметров = ВнутреннийКонструкторПараметров.ВСтруктуру();
	
	Лог.Отладка("Вызываю <УстановитьПараметры> для объекта <%1>", КлассПараметров);
	КлассПараметров.УстановитьПараметры(СтруктураПараметров);
	
КонецПроцедуры

Процедура ПоказатьНастройкиВРежимеОтладки(ЗначенияПараметров)

	ПроцессорВывода = Новый ВыводВРежимеОтладки(Лог);
	ПроцессорВывода.ПоказатьНастройкиВРежимеОтладки(ЗначенияПараметров);

КонецПроцедуры

Функция ПолучитьНастройкуФайловогоПровайдера()

	Если НастройкаФайловогоПровайдера = Неопределено Тогда
		 НастройкаФайловогоПровайдера = Новый НастройкиФайловогоПровайдера;
	КонецЕсли;

	Возврат НастройкаФайловогоПровайдера;

КонецФункции

#КонецОбласти

#Область Инициализация

Процедура ПриСозданииОбъекта()

	ИндексПараметров = Новый ИндексЗначений;
	ИндексПараметров.Коллекция(Новый Соответствие);
	
	ПрочитанныеПараметры = Новый Соответствие;
	ПровайдерыПараметров = Новый Соответствие;
	ЧтениеПараметровВыполнено = Ложь;

	ИнтерфейсПриемника = Новый ИнтерфейсОбъекта;
	ИнтерфейсПриемника.П("УстановитьПараметры", 1);
	ИнтерфейсПриемника.Ф("ОписаниеПараметров", 1);

	ВнутреннийКонструкторПараметров = Неопределено;
	ИспользуетсяКонструкторПараметров = Ложь;

КонецПроцедуры

Функция ИнтерфейсРеализован(Интерфейс, КлассОбъект, ВыдатьОшибку = Ложь)

	РефлекторОбъекта = Новый РефлекторОбъекта(КлассОбъект);
	Возврат РефлекторОбъекта.РеализуетИнтерфейс(Интерфейс, ВыдатьОшибку);

КонецФункции

#КонецОбласти

Лог = Логирование.ПолучитьЛог("oscript.lib.configor");