﻿
Функция НайтиСоздатьДопКолонку(ИмяДокумента, ИмяТаблицы, ИмяКолонки, Заголовок, ОписаниеТипа) Экспорт
	
	ИдентификаторДокумента = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("ДокументСсылка."+ИмяДокумента));
	МетаданныеДокумента = Метаданные.НайтиПоТипу(Тип("ДокументСсылка."+ИмяДокумента));
	ТабличнаяЧастьДокумента = МетаданныеДокумента.ТабличныеЧасти.Найти(ИмяТаблицы);
	
	Если ТабличнаяЧастьДокумента.Реквизиты.Найти(ИмяКолонки) <> Неопределено Тогда  
		// дублирование полей документа
		Возврат Неопределено;	
	КонецЕсли;

	Редактирование_ДопТЧ = ПравоДоступа("Редактирование", Метаданные.Справочники.ДополнительныеТабличныеЧастиДокументов);
	Редактирование_ДопКолонки = ПравоДоступа("Редактирование", Метаданные.Справочники.КолонкиДополнительныхТабличныхЧастей);
	Редактирование_ДопРеквизиты = ПравоДоступа("Редактирование", Метаданные.ПланыВидовХарактеристик.ДополнительныеРеквизитыОпераций);

	СозданиеДоступно = Редактирование_ДопТЧ И Редактирование_ДопКолонки	И Редактирование_ДопРеквизиты;
	          	
	// Поиск создание ДопТабчасти
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДополнительныеТабличныеЧастиДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДополнительныеТабличныеЧастиДокументов КАК ДополнительныеТабличныеЧастиДокументов
	|ГДЕ
	|	ДополнительныеТабличныеЧастиДокументов.ИдентификаторДокумента = &ИдентификаторДокумента
	|	И ДополнительныеТабличныеЧастиДокументов.ИмяТабличнойЧасти = &ИмяТабличнойЧасти");	
	Запрос.Параметры.Вставить("ИдентификаторДокумента", ИдентификаторДокумента);
	Запрос.Параметры.Вставить("ИмяТабличнойЧасти", 		ИмяТаблицы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДопТабЧасть = Выборка.Ссылка;
		Если ДопТабЧасть.ПометкаУдаления = Истина Тогда
			ДопТабЧастьОбъект = ДопТабЧасть.ПолучитьОбъект();
			ДопТабЧастьОбъект.УстановитьПометкуУдаления(Ложь);
			ДопТабЧастьОбъект.Наименование = "Материалы";
			ДопТабЧастьОбъект.Записать();
		КонецЕсли;
	ИначеЕсли СозданиеДоступно Тогда
		ДопТабЧастьОбъект = Справочники.ДополнительныеТабличныеЧастиДокументов.СоздатьЭлемент();
		ДопТабЧастьОбъект.ИдентификаторДокумента = ИдентификаторДокумента; 
		ДопТабЧастьОбъект.ИмяТабличнойЧасти = ИмяТаблицы;
		
		Если ТабличнаяЧастьДокумента <> Неопределено Тогда   
			ДопТабЧастьОбъект.ПредопределеннаяТабличнаяЧасть = Истина;
			ДопТабЧастьОбъект.Наименование = ТабличнаяЧастьДокумента.Синоним;                   
		Иначе       
			// Новую кастомную ТабЧасть не создаем
			Возврат Неопределено;
		КонецЕсли;                         
		
		ДопТабЧастьОбъект.Записать();
		ДопТабЧасть = ДопТабЧастьОбъект.Ссылка; 
	Иначе
		Возврат Неопределено;
	КонецЕсли;  
	

	// Поиск Создание ДопКолонки
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КолонкиДополнительныхТабличныхЧастей.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КолонкиДополнительныхТабличныхЧастей КАК КолонкиДополнительныхТабличныхЧастей
	|ГДЕ
	|	КолонкиДополнительныхТабличныхЧастей.Владелец = &Владелец
	|	И КолонкиДополнительныхТабличныхЧастей.ИмяКолонки = &ИмяКолонки");	
	Запрос.Параметры.Вставить("Владелец", ДопТабЧасть);
	Запрос.Параметры.Вставить("ИмяКолонки", ИмяКолонки);  
	
	Выборка = запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДопКолонка = Выборка.Ссылка;
		Если ДопКолонка.ПометкаУдаления = Истина Тогда
			ДопКолонкаОбъект = ДопКолонка.ПолучитьОбъект();
			ДопКолонкаОбъект.УстановитьПометкуУдаления(Ложь);
			ДопКолонкаОбъект.Записать();
		КонецЕсли;
	ИначеЕсли СозданиеДоступно Тогда
		 
		ДопКолонкаОбъект = Справочники.КолонкиДополнительныхТабличныхЧастей.СоздатьЭлемент();
		ДопКолонкаОбъект.Владелец = ДопТабЧасть; 
		ДопКолонкаОбъект.ИмяКолонки = ИмяКолонки;
		
		// Поиск создание типа колонки - по прямому сходству типа и наименованию
		ЗапросПоТипу = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДополнительныеРеквизитыОпераций.Ссылка КАК Ссылка,
		|	ДополнительныеРеквизитыОпераций.ТипЗначения КАК ТипЗначения
		|ИЗ
		|	ПланВидовХарактеристик.ДополнительныеРеквизитыОпераций КАК ДополнительныеРеквизитыОпераций
		|ГДЕ
		|	ДополнительныеРеквизитыОпераций.Наименование = &Наименование"); 
		ЗапросПоТипу.Параметры.Вставить("Наименование", ИмяКолонки);
		ВыборкаТиповДопКолонок = ЗапросПоТипу.Выполнить().Выбрать();  
		
		ТипДляКолонки = Неопределено;	
		Пока ВыборкаТиповДопКолонок.Следующий() Цикл 
			Если ВыборкаТиповДопКолонок.ТипЗначения = ОписаниеТипа Тогда
				ТипДляКолонки = ВыборкаТиповДопКолонок.Ссылка;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ТипДляКолонки = Неопределено И СозданиеДоступно Тогда
			ОписаниеТипаОбъект = ПланыВидовХарактеристик.ДополнительныеРеквизитыОпераций.СоздатьЭлемент(); 
			ОписаниеТипаОбъект.ТипЗначения = ОписаниеТипа;  
			ОписаниеТипаОбъект.Наименование = ИмяКолонки; 
			ОписаниеТипаОбъект.Записать();
			ТипДляКолонки = ОписаниеТипаОбъект.Ссылка;	
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
		ДопКолонкаОбъект.Наименование = Заголовок;
		ДопКолонкаОбъект.ОписаниеТипаКолонки = ТипДляКолонки;
		ДопКолонкаОбъект.Записать();    
		
       	ДопКолонка = ДопКолонкаОбъект.Ссылка;
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;  
	
	Возврат Новый Структура("ДопТабЧасть,ДопКолонка",ДопТабЧасть,ДопКолонка);
	
КонецФункции  

Функция НайтиСоздатьДополнительноеСведение(ИдентификаторДляФормул) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторДляФормул", ИдентификаторДляФормул);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДополнительныеРеквизитыИСведения.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДополнительныеРеквизитыИСведения
	|ГДЕ
	|	ДополнительныеРеквизитыИСведения.ИдентификаторДляФормул = &ИдентификаторДляФормул";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	ДопСведение = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
	ДопСведение.Наименование = ИдентификаторДляФормул;       
	ДопСведение.Заголовок = ИдентификаторДляФормул;
	ДопСведение.ИдентификаторДляФормул = ИдентификаторДляФормул;
	ДопСведение.Виден = Ложь;
	ДопСведение.Комментарий = "Техничесикий доп реквизит для работы расширения";
	ДопСведение.ТипЗначения = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(1024));
	ДопСведение.ЭтоДополнительноеСведение = Ложь;  
	
	// Формирование имени дополнительного реквизита (сведения).
	Если Не ЗначениеЗаполнено(ДопСведение.Имя) Тогда
		ДопСведение.Имя = "";
		ЗаголовокОбъекта = ДопСведение.Заголовок;
		УправлениеСвойствамиСлужебный.УдалитьНедопустимыеСимволы(ЗаголовокОбъекта);
		ЗаголовокОбъектаЧастями = СтрРазделить(ЗаголовокОбъекта, " ", Ложь);
		Для Каждого ЧастьЗаголовка Из ЗаголовокОбъектаЧастями Цикл
			ДопСведение.Имя = ДопСведение.Имя + ВРег(Лев(ЧастьЗаголовка, 1)) + Сред(ЧастьЗаголовка, 2);
		КонецЦикла;
		
		Если ИмяНачинаетсяСЦифры(ДопСведение.Имя) Тогда
			ДопСведение.Имя = "_" + ДопСведение.Имя;
		КонецЕсли;
		
		УИД = Новый УникальныйИдентификатор();
		СтрокаУИД = СтрЗаменить(Строка(УИД), "-", "");
		ДопСведение.Имя = ДопСведение.Имя + "_" + СтрокаУИД;
	КонецЕсли;
	
	ДопСведение.Записать();
	
	Возврат ДопСведение.Ссылка;
	
КонецФункции  

Функция ИмяНачинаетсяСЦифры(ИмяРеквизита)
	ПервыйСимвол = Лев(ИмяРеквизита, 1);
	Если СтрНайти("0123456789", ПервыйСимвол) > 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

