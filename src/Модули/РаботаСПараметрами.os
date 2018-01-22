#Использовать json

Перем мЧтениеJSON;
Перем мПрочитанныеПараметры;
Перем мОшибкиЧтения;

Перем МассивФайловКонфигурации;
Перем ВнутреннийМенеджерКонфигурации; // Функция _() инициализирует или возвращает эту переменную 

Процедура УстановитьФайлПараметров(Знач ПутьКФайлу) Экспорт

	_().УстановитьФайлПараметров(ПутьКФайлу);

КонецПроцедуры

Процедура ДобавитьКаталогПоиска(Знач ПутьПоискаФайлов) Экспорт

	_().ДобавитьКаталогПоиска(ПутьПоискаФайлов);
	
КонецПроцедуры

Процедура УстановитьИмяФайла(Знач ИмяФайла) Экспорт
	
	_().УстановитьИмяФайла(ИмяФайла);

КонецПроцедуры

Функция Параметр(Знач ИмяПараметра, Знач ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Если НЕ _().ЧтениеВыполнено() Тогда
		Прочитать();
	КонецЕсли;

	Возврат _().Параметр(ИмяПараметра, ЗначениеПоУмолчанию);

КонецФункции

Процедура УстановитьРасширениеФайла(Знач РасширениеФайла, Знач КлассЧтенияФайла = Неопределено) Экспорт
	_().УстановитьРасширениеФайла(РасширениеФайла, КлассЧтенияФайла);
КонецПроцедуры
//
Функция ИспользуемыйФайлПараметров() Экспорт
	Возврат _().ИспользуемыйФайлПараметров();
КонецФункции

Процедура НовыеПараметры(КлассПараметров) Экспорт
	
	ВнутреннийМенеджерКонфигурации = Новый МенеджерЧтенияКонфигурации();
	ВнутреннийМенеджерКонфигурации.УстановитьКлассПриемник(КлассПараметров);

КонецПроцедуры

Процедура УстановитьКлассПриемник(КлассПараметров)
	_().УстановитьКлассПриемник(КлассПараметров);
КонецПроцедуры

Процедура Прочитать() Экспорт
	_().Прочитать();
КонецПроцедуры

Функция _()
	Если ВнутреннийМенеджерКонфигурации = Неопределено Тогда
		ВнутреннийМенеджерКонфигурации = Новый МенеджерЧтенияКонфигурации();
	КонецЕсли;
	Возврат ВнутреннийМенеджерКонфигурации;
КонецФункции