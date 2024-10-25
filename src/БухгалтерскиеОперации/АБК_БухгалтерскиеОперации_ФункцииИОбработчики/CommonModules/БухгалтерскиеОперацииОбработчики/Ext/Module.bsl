﻿
&После("ЗаполнитьСписокОбработчиков")
Процедура АБК_ЗаполнитьСписокОбработчиков(СписокОбработчиков)
	
	СписокОбработчиков.Добавить("СформироватьДвиженияБСОПоСчетам_03",
		"Обработчик события ""Сформировать движения БСО После формирования проводок типовой операции""");
	
КонецПроцедуры

Процедура СформироватьДвиженияБСОПоСчетам_03(ТаблицаПроводок, ДокументОбъект, ДополнительныеРеквизиты)
	
	МассивСчетов03 = БухгалтерскийУчет.СписокСчетов("03.1,03.2,03.3,03.4");
	
	ДвиженияПоБСО = ДокументОбъект.Движения.ДвиженияБСО;
	ДвиженияПоБСО.Очистить();
	ДвиженияПоБСО.Записывать = Истина;
		
	Для Каждого ПроводкаБУ из ТаблицаПроводок Цикл
		
		Если МассивСчетов03.Найти(ПроводкаБУ.СчетДт) <> Неопределено Тогда
			ДобавитьДвижениеПоБСО(ДвиженияПоБСО,ПроводкаБУ,ДокументОбъект.СоставБСО,"Дт");	
		КонецЕсли;
		
		Если МассивСчетов03.Найти(ПроводкаБУ.СчетКт) <> Неопределено Тогда
			ДобавитьДвижениеПоБСО(ДвиженияПоБСО,ПроводкаБУ,ДокументОбъект.СоставБСО,"Кт");	
		КонецЕсли;
		
	КонецЦикла;
	
	ДокументОбъект.ДополнительныеСвойства.Вставить("ТаблицаДвиженийБСО",ДвиженияПоБСО.Выгрузить());
	
КонецПроцедуры    

Процедура ДобавитьДвижениеПоБСО(ДвиженияПоБСО,ПроводкаБУ,СоставБСО,ДтКт)
		
	СтрокаДвижения = ДвиженияПоБСО.Добавить();
	Если ДтКт = "Дт" Тогда
		СтрокаДвижения.ВидДвижения = ВидДвиженияНакопления.Приход;	
	Иначе
		СтрокаДвижения.ВидДвижения = ВидДвиженияНакопления.Расход;	
	КонецЕсли;    
	
	ЗаполнитьЗначенияСвойств(СтрокаДвижения,ПроводкаБУ,"Организация,Период,Регистратор,КФО,ИФО");
	
	Для i = 1 По 3 Цикл 
		
		Если ПроводкаБУ["ВидСубконто"+ДтКт+i] = ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконто.ЦМО") Тогда
			СтрокаДвижения.ЦМО = ПроводкаБУ["Субконто"+ДтКт+i];	
		КонецЕсли;
		
		Если ПроводкаБУ["ВидСубконто"+ДтКт+i] = ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконто.БСО") Тогда
			СтрокаДвижения.БСО = ПроводкаБУ["Субконто"+ДтКт+i];	
		КонецЕсли;
		
	КонецЦикла;
	
	СтрокаДвижения.СчетУчета = ПроводкаБУ["Счет"+ДтКт];
	СтрокаДвижения.Количество = ПроводкаБУ["Количество"+ДтКт];
	СтрокаДвижения.Подразделение = ПроводкаБУ["Подразделение"+ДтКт];

	// Серия и номера БСО
	ТипЧисло = Новый ОписаниеТипов("Число");
	НомерСтрокиИзДокумента = ТипЧисло.ПривестиЗначение(ПроводкаБУ.Содержание);  
	
	СтруктураНомерСерия = Новый Структура("СерияБСО,НомерНачальный,НомерКонечный");
	
	Если НомерСтрокиИзДокумента > 0 Тогда
		СтрокаИзДокумента = СоставБСО.Найти(НомерСтрокиИзДокумента,"НомерСтроки");
		Если СтрокаИзДокумента <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтруктураНомерСерия,СтрокаИзДокумента);
		КонецЕсли;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(СтрокаДвижения,СтруктураНомерСерия);
	
КонецПроцедуры

&ИзменениеИКонтроль("ВыполнитьОбработчик")
Процедура АБК_ВыполнитьОбработчик(ИмяПроцедуры, ТаблицаПроводок, ДокументОбъект, ДополнительныеРеквизиты)

	СоставИмениПроцедуры = СтрРазделить(ИмяПроцедуры, ".");

	Если СоставИмениПроцедуры.Количество() = 1 Тогда

		// Проверить, что передано допустимое имя процедуры
		ВременнаяСтруктура = Новый Структура(ИмяПроцедуры);

		Выполнить(СтрШаблон("%1(ТаблицаПроводок, ДокументОбъект, ДополнительныеРеквизиты)", ИмяПроцедуры));

	ИначеЕсли СоставИмениПроцедуры.Количество() = 2 Тогда

		// Проверить, что передано допустимое имя процедуры
		ВременнаяСтруктура = Новый Структура(СоставИмениПроцедуры[1]);

		ДополнительныеМодули = БухгалтерскиеОперацииСервер.ОписанияМодулейРасширений("Обработчики");
		ФункцияИзДополнительногоМодуля = ДополнительныеМодули.Свойство(СоставИмениПроцедуры[0]);
		ИсполняемоеИмяПроцедуры = СтрШаблон("%1.ВыполнитьПроцедуруОбработчика(""%2"", ТаблицаПроводок, ДокументОбъект, ДополнительныеРеквизиты)",
		?(ФункцияИзДополнительногоМодуля, СоставИмениПроцедуры[0],
		"БухгалтерскиеОперацииОбработчикиПереопределяемый"),
		СоставИмениПроцедуры[1]);

		Выполнить(ИсполняемоеИмяПроцедуры);

	Иначе

		ВызватьИсключение "";

	КонецЕсли;

КонецПроцедуры
