﻿
&НаСервере
Процедура АБК_ЗаполнитьМаршрутПоУчетномуДокументуПослеНаСервере()  
	УчетныйДокумент = Объект.УчетныйДокумент;     
	
	МассивФизлиц = Новый Массив;  
	
	Если ТипЗнч(Объект.УчетныйДокумент) = Тип("ДокументСсылка.РегистрУчета") Тогда   
		ИскомыеРеквизиты = Новый Массив;
		ИскомыеРеквизиты.Добавить("Исполнитель");
		ИскомыеРеквизиты.Добавить("ЦМО");
		ИскомыеРеквизиты.Добавить("Ответственный");
		ИскомыеРеквизиты.Добавить("Исполнитель");
		ИскомыеРеквизиты.Добавить("Руководитель");
		ИскомыеРеквизиты.Добавить("Сотрудник");
		
		МассивСотрудников_ЦМО = ПолучитьРеквизитыПользовательскихНастроекРегистраУчета(ИскомыеРеквизиты);
		
		Для Каждого ЗначениеСоставногоРеквизита из МассивСотрудников_ЦМО Цикл 
			
			Если ТипЗнч(ЗначениеСоставногоРеквизита) = Тип("СправочникСсылка.ЦМО") Тогда
				
				ДобавитьПользователяСотрудника(ЗначениеСоставногоРеквизита.Сотрудник, МассивФизлиц);
				
			ИначеЕсли ТипЗнч(ЗначениеСоставногоРеквизита) = Тип("СправочникСсылка.Сотрудники") Тогда               
				
				ДобавитьПользователяСотрудника(ЗначениеСоставногоРеквизита, МассивФизлиц);
				
			КонецЕсли;  
			
		КонецЦикла;
	Иначе
		МетаданныеУчетногоДокумента = УчетныйДокумент.Метаданные();
		
		МассивВозможныхРеквизитовСотрудников = Новый Массив;
		МассивВозможныхРеквизитовСотрудников.Добавить("РуководительФинЭкономПодразделения");
		МассивВозможныхРеквизитовСотрудников.Добавить("ОтветственныйФинЭкономПодразделения");
		МассивВозможныхРеквизитовСотрудников.Добавить("ОтветственныйИсполнительБух");
		МассивВозможныхРеквизитовСотрудников.Добавить("ОтветственныйИсполнительКадры");
		МассивВозможныхРеквизитовСотрудников.Добавить("Сотрудник"); 
		МассивВозможныхРеквизитовСотрудников.Добавить("СотрудникЛП"); 
		МассивВозможныхРеквизитовСотрудников.Добавить("Затребовал");
		МассивВозможныхРеквизитовСотрудников.Добавить("ОтпускРазрешил");
		МассивВозможныхРеквизитовСотрудников.Добавить("РуководительПодразделения");
		МассивВозможныхРеквизитовСотрудников.Добавить("ОтветственныйЗаПроверкуДокументов");
		МассивВозможныхРеквизитовСотрудников.Добавить("Руководитель");
		МассивВозможныхРеквизитовСотрудников.Добавить("ОтветственныйИсполнитель");
		МассивВозможныхРеквизитовСотрудников.Добавить("Председатель");
		МассивВозможныхРеквизитовСотрудников.Добавить("Бухгалтер");
		МассивВозможныхРеквизитовСотрудников.Добавить("ГлавныйБухгалтер");
		МассивВозможныхРеквизитовСотрудников.Добавить("ПодотчетноеЛицо");
		МассивВозможныхРеквизитовСотрудников.Добавить("ОтветственныйКонтрактнойСлужбы");
		МассивВозможныхРеквизитовСотрудников.Добавить("РуководительОрганизацииОсуществляющейОбеспечение"); 
		МассивВозможныхРеквизитовСотрудников.Добавить("ПредставительОрганизации");
		
		Если ТипЗнч(Объект.УчетныйДокумент) = Тип("ДокументСсылка.АктСверкиВзаиморасчетов") 
			И ЗначениеЗаполнено(УчетныйДокумент.Ответственный) Тогда 
			МассивФизлиц.Добавить(УчетныйДокумент.Ответственный.ФизическоеЛицо);		
		КонецЕсли;	
		
		Для Каждого РеквизитСотрудника из МассивВозможныхРеквизитовСотрудников Цикл
			Если ОбщегоНазначенияБГУ.ЕстьРеквизитДокумента(РеквизитСотрудника, МетаданныеУчетногоДокумента) Тогда    
				
				ДобавитьПользователяСотрудника(УчетныйДокумент[РеквизитСотрудника], МассивФизлиц);     
				
			КонецЕсли;
		КонецЦикла;               
		
		МассивВозможныхТабличныхЧастей = Новый Массив;    
		МассивВозможныхТабличныхЧастей.Добавить("ЛистСогласования");
		МассивВозможныхТабличныхЧастей.Добавить("ЛистОзнакомления");
		МассивВозможныхТабличныхЧастей.Добавить("СоставКомиссии");  
		
		Для Каждого ТабличнаяЧасть из МассивВозможныхТабличныхЧастей Цикл
			Если ОбщегоНазначенияБГУ.ЕстьТабЧастьДокумента(ТабличнаяЧасть, МетаданныеУчетногоДокумента) Тогда   
				
				Если ОбщегоНазначенияБГУ.ЕстьРеквизитТабЧастиДокумента("Сотрудник", МетаданныеУчетногоДокумента, ТабличнаяЧасть) Тогда   
					Для Каждого Стр из УчетныйДокумент[ТабличнаяЧасть] Цикл  
						
						ДобавитьПользователяСотрудника(Стр.Сотрудник, МассивФизлиц);  
						
					КонецЦикла; 
				ИначеЕсли ОбщегоНазначенияБГУ.ЕстьРеквизитТабЧастиДокумента("ФамилияЧленаКомиссии", МетаданныеУчетногоДокумента, ТабличнаяЧасть)
					И ОбщегоНазначенияБГУ.ЕстьРеквизитТабЧастиДокумента("ИмяЧленаКомиссии", МетаданныеУчетногоДокумента, ТабличнаяЧасть)
					И ОбщегоНазначенияБГУ.ЕстьРеквизитТабЧастиДокумента("ОтчествоЧленаКомиссии", МетаданныеУчетногоДокумента, ТабличнаяЧасть) Тогда
					Для Каждого Стр из УчетныйДокумент[ТабличнаяЧасть] Цикл   
						ФИОСотрудника = "" + Стр.ФамилияЧленаКомиссии + " " + Стр.ИмяЧленаКомиссии + " " + Стр.ОтчествоЧленаКомиссии;
						Сотрудник = Справочники.Сотрудники.НайтиПоНаименованию(ФИОСотрудника);
						
						Если ЗначениеЗаполнено(Сотрудник) Тогда       
							
							ДобавитьПользователяСотрудника(Сотрудник, МассивФизлиц);	  
							
						КонецЕсли;
					КонецЦикла; 
				КонецЕсли; 
				
			КонецЕсли;
		КонецЦикла;     
		
		Если ОбщегоНазначенияБГУ.ЕстьРеквизитДокумента("ФамилияПредседателяКомиссии", МетаданныеУчетногоДокумента)
			И ОбщегоНазначенияБГУ.ЕстьРеквизитДокумента("ИмяПредседателяКомиссии", МетаданныеУчетногоДокумента)
			И ОбщегоНазначенияБГУ.ЕстьРеквизитДокумента("ОтчествоПредседателяКомиссии", МетаданныеУчетногоДокумента) Тогда
			
			ФИОСотрудника = "" + УчетныйДокумент["ФамилияПредседателяКомиссии"] + " " + УчетныйДокумент["ИмяПредседателяКомиссии"] + " " + УчетныйДокумент["ОтчествоПредседателяКомиссии"];
			Сотрудник = Справочники.Сотрудники.НайтиПоНаименованию(ФИОСотрудника);
			
			Если ЗначениеЗаполнено(Сотрудник) Тогда
							
				ДобавитьПользователяСотрудника(Сотрудник, МассивФизлиц);	  
							
			КонецЕсли;
			
		КонецЕсли;
		
		МассивВозможныхСоставныхРеквизитов = Новый Массив;
		МассивВозможныхСоставныхРеквизитов.Добавить("МОЛ");
		МассивВозможныхСоставныхРеквизитов.Добавить("ЦМООтправитель");      
		МассивВозможныхСоставныхРеквизитов.Добавить("ЦМОПолучатель"); 
		МассивВозможныхСоставныхРеквизитов.Добавить("ЦМО");      
		МассивВозможныхСоставныхРеквизитов.Добавить("ЦМОПриПередаче");  
		
		Для Каждого СоставнойРеквизит из МассивВозможныхСоставныхРеквизитов Цикл
			Если ОбщегоНазначенияБГУ.ЕстьРеквизитДокумента(СоставнойРеквизит, МетаданныеУчетногоДокумента)
				И ЗначениеЗаполнено(УчетныйДокумент[СоставнойРеквизит]) Тогда 
				
				ЗначениеСоставногоРеквизита = УчетныйДокумент[СоставнойРеквизит];
				
				Если ТипЗнч(ЗначениеСоставногоРеквизита) = Тип("СправочникСсылка.ЦМО") Тогда
					
					ДобавитьПользователяСотрудника(ЗначениеСоставногоРеквизита.Сотрудник, МассивФизлиц);	  
					
				ИначеЕсли ТипЗнч(ЗначениеСоставногоРеквизита) = Тип("СправочникСсылка.Сотрудники") Тогда               
					
					ДобавитьПользователяСотрудника(ЗначениеСоставногоРеквизита, МассивФизлиц);	  
					
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;    
		
	КонецЕсли;
	
	Если МассивФизлиц.Количество() Тогда  
		
		ОбщегоНазначенияБГУ.УдалитьПовторяющиесяЭлементыМассива(МассивФизлиц);
		
		ТаблицаПодписантов = ПолучитьТаблицуПодписантов(МассивФизлиц);  
		
		ДеревоЗначений = РеквизитФормыВЗначение("ДеревоМаршрута");
		ДеревоЗначений.Строки.Очистить();
		
		СтрокаПервого = ДеревоЗначений.Строки.Добавить();
		СтрокаПервого.Группа = "И"; 
		СтрокаПервого.ИндексКартинки = 2;
		СтрокаПервого.ОсновноеЗначение = "Все одновременно";
		СтрокаПервого.ЭтоСтрокаУсловия = Истина;
		
		Для Каждого Стр из ТаблицаПодписантов Цикл
			СтрокаВторого = СтрокаПервого.Строки.Добавить();
			СтрокаВторого.ВидПодписи = Стр.ВидПодписи;
			СтрокаВторого.ОсновноеЗначение = Стр.Подписант;
			СтрокаВторого.Подписант = Стр.Подписант;
			СтрокаВторого.ЭтоСтрокаУсловия = Ложь;
		КонецЦикла;  
		
		МаршрутПодписания = "";
		ЗначениеВРеквизитФормы(ДеревоЗначений, "ДеревоМаршрута");
		
	Иначе
		
		Сообщить("Не найдены пользователи по выбранным сотрудникам или выбраны неподходящие документы!");
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АБК_ЗаполнитьМаршрутПоУчетномуДокументуПосле(Команда)
	Если Объект.Ссылка.Пустая() Тогда
		АБК_ЗаполнитьМаршрутПоУчетномуДокументуПослеНаСервере();    
		
		ПредставлениеМаршрута = ВнутреннийЭДОКлиент.ПредставлениеМаршрутаПоДереву(ДеревоМаршрута);   
		
		ЗаполнитьДеревоМаршрута();
		
		РазвернутьДеревоМаршрута();
		
		ОбновитьСоставКомандДействий();  
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьФизлицоСотрудника(Сотрудник)       
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда  
		Контрагент = Сотрудник.Контрагент;  
		
		Если ЗначениеЗаполнено(Контрагент) Тогда
			Возврат Контрагент.ЮридическоеФизическоеЛицо;	
		КонецЕсли;  
	КонецЕсли;                           
	
	Возврат Справочники.ФизическиеЛица.ПустаяСсылка();       
	
КонецФункции

&НаСервере
Функция ПолучитьТаблицуПодписантов(МассивФизлиц)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СоставМаршрутаЭлектронногоДокумента.Подписант КАК Подписант,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоставМаршрутаЭлектронногоДокумента.ВидПодписи) КАК ВидПодписи
	|ПОМЕСТИТЬ КоличествоВидовПодписей
	|ИЗ
	|	РегистрСведений.СоставМаршрутаЭлектронногоДокумента КАК СоставМаршрутаЭлектронногоДокумента
	|ГДЕ
	|	НЕ СоставМаршрутаЭлектронногоДокумента.ЭлектронныйДокумент.ПометкаУдаления
	|	И СоставМаршрутаЭлектронногоДокумента.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументовВнутреннегоЭДО.Завершен)
	|
	|СГРУППИРОВАТЬ ПО
	|	СоставМаршрутаЭлектронногоДокумента.Подписант
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоставМаршрутаЭлектронногоДокумента.Подписант КАК Подписант,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(КоличествоВидовПодписей.ВидПодписи, 0) > 1
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыЭлектронныхПодписейБГУ.Усиленная)
	|		ИНАЧЕ СоставМаршрутаЭлектронногоДокумента.ВидПодписи
	|	КОНЕЦ КАК ВидПодписи
	|ПОМЕСТИТЬ ВидПодписиПоПодписанту
	|ИЗ
	|	РегистрСведений.СоставМаршрутаЭлектронногоДокумента КАК СоставМаршрутаЭлектронногоДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоВидовПодписей КАК КоличествоВидовПодписей
	|		ПО (КоличествоВидовПодписей.Подписант = СоставМаршрутаЭлектронногоДокумента.Подписант)
	|ГДЕ
	|	НЕ СоставМаршрутаЭлектронногоДокумента.ЭлектронныйДокумент.ПометкаУдаления
	|	И СоставМаршрутаЭлектронногоДокумента.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументовВнутреннегоЭДО.Завершен)
	|
	|СГРУППИРОВАТЬ ПО
	|	СоставМаршрутаЭлектронногоДокумента.Подписант,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(КоличествоВидовПодписей.ВидПодписи, 0) > 1
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыЭлектронныхПодписейБГУ.Усиленная)
	|		ИНАЧЕ СоставМаршрутаЭлектронногоДокумента.ВидПодписи
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(Пользователи.Ссылка) КАК Подписант,
	|	Пользователи.ФизическоеЛицо КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ПользователиПоФизлицу
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.ФизическоеЛицо В(&МассивФизлиц)
	|	И НЕ Пользователи.ФизическоеЛицо = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|	И НЕ Пользователи.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	Пользователи.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПользователиПоФизлицу.Подписант КАК Подписант,
	|	ЕСТЬNULL(ВидПодписиПоПодписанту.ВидПодписи, ЗНАЧЕНИЕ(Перечисление.ВидыЭлектронныхПодписейБГУ.Простая)) КАК ВидПодписи
	|ИЗ
	|	ПользователиПоФизлицу КАК ПользователиПоФизлицу
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВидПодписиПоПодписанту КАК ВидПодписиПоПодписанту
	|		ПО (ВидПодписиПоПодписанту.Подписант = ПользователиПоФизлицу.Подписант)");
	Запрос.УстановитьПараметр("МассивФизлиц",МассивФизлиц);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
&После("УправлениеВидимостьюЭлементовФормы")
Процедура АБК_УправлениеВидимостьюЭлементовФормы()
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	Элементы, "ЗаполнитьМаршрутПоУчетномуДокументу", "Видимость", Объект.Ссылка.Пустая());
	
КонецПроцедуры

&НаСервере
Процедура АБК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	НовЭл = Элементы.Добавить("ЗаполнитьМаршрутПоУчетномуДокументу",Тип("КнопкаФормы"),ЭтаФорма.КоманднаяПанель); 
	НовЭл.ИмяКоманды = "ЗаполнитьМаршрутПоУчетномуДокументу"; 
	НовЭл.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	Элементы, "ЗаполнитьМаршрутПоУчетномуДокументу", "Видимость", Объект.Ссылка.Пустая());
КонецПроцедуры

&НаСервере
Функция ПолучитьРеквизитыПользовательскихНастроекРегистраУчета(ИскомыеРеквизиты)  
	МассивЗначенийРеквизитов = Новый Массив;
	
	УчетныйДокумент = Объект.УчетныйДокумент;
	
	КомпоновщикНастроек = ИнициализироватьКомпоновщикНастроек(УчетныйДокумент); 
	
	Если КомпоновщикНастроек <> Неопределено Тогда
		
		ПользовательскиеНастройки  = КомпоновщикНастроек.ПользовательскиеНастройки;
		
		ЭлементыПараметровОтчета = ПользовательскиеНастройки.Элементы;
		
		Для Каждого ИскомыйРеквизит из ИскомыеРеквизиты Цикл
			Для Каждого Стр из ЭлементыПараметровОтчета Цикл
				Если ТипЗнч(Стр) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
					И Строка(Стр.Параметр) = ИскомыйРеквизит Тогда 	  
					
					МассивЗначенийРеквизитов.Добавить(Стр.Значение);      
					
				ИначеЕсли ТипЗнч(Стр) = Тип("ЭлементОтбораКомпоновкиДанных")
					И ЗначениеЗаполнено(Стр.ИдентификаторПользовательскойНастройки) Тогда
					
					МассивОсновныхНастроек = ПользовательскиеНастройки.ПолучитьОсновныеНастройкиПоИдентификаторуПользовательскойНастройки(Стр.ИдентификаторПользовательскойНастройки);
					
					Если МассивОсновныхНастроек.Количество() Тогда
						Если Строка(МассивОсновныхНастроек[0].ЛевоеЗначение) = ИскомыйРеквизит Тогда
							МассивЗначенийРеквизитов.Добавить(Стр.ПравоеЗначение);      
						КонецЕсли;
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;                                         
		КонецЦикла;    
		
	КонецЕсли;
	
	Возврат МассивЗначенийРеквизитов;
КонецФункции        

&НаСервере
Функция ИнициализироватьКомпоновщикНастроек(УчетныйДокумент,
	
	ОбъектРегистр = "Объект", Компоновщик = "КомпоновщикНастроекКД", 
	ПользовательскиеНастройки = "ПользовательскиеНастройкиОтчета")    
	
	ВариантОтчета = УчетныйДокумент.ВидРегистра.ВариантОтчета;
	СохраненныеНастройки = УчетныйДокумент.ПолучитьОбъект()[ПользовательскиеНастройки].Получить();
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("СсылкаВарианта",              ВариантОтчета);
	ПараметрыПодключения.Вставить("ПользовательскиеНастройкиКД", СохраненныеНастройки);
	
	Подключение = ВариантыОтчетов.ПодключитьОтчетИЗагрузитьНастройки(ПараметрыПодключения);
	
	Если Подключение.Успех Тогда
		Возврат Подключение.Объект.КомпоновщикНастроек;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ДобавитьПользователяСотрудника(Сотрудник, МассивФизлиц)        
	
	Физлицо = ПолучитьФизлицоСотрудника(Сотрудник); 
	
	Если ЗначениеЗаполнено(Физлицо) Тогда
		МассивФизлиц.Добавить(Физлицо);		
	КонецЕсли;
					
КонецФункции

