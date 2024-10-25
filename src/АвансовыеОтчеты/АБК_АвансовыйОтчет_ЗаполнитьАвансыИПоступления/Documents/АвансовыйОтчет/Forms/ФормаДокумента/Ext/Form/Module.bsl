﻿
&НаСервере
Процедура АБК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)   
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ДобавитьЭлементы();	
		
	КонецЕсли;  
	
КонецПроцедуры

&НаСервере
Процедура АБК_ПриЧтенииНаСервереПосле(ТекущийОбъект)      
	
	ДобавитьЭлементы();	     
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементы()     
	
	Если НЕ ЭлементыДобавлены Тогда  
		
		НовЭл = Элементы.Добавить("ПериодЗаполнения", Тип("ПолеФормы"), Элементы.ШапкаДокумента);
		НовЭл.ПутьКДанным = "ПериодЗаполнения";
		НовЭл.Вид = ВидПоляФормы.ПолеВвода;     
		
		НовЭлКоманды = Элементы.Добавить("ЗаполнитьТаблицуИзрасходовано", Тип("КнопкаФормы"), Элементы.Израсходовано.КоманднаяПанель);
		НовЭлКоманды.ИмяКоманды = "ЗаполнитьТаблицуИзрасходовано";
		НовЭлКоманды.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
		
		НовЭлКоманды = Элементы.Добавить("ЗаполнитьТаблицуВнесенияОстатка", Тип("КнопкаФормы"), Элементы.ОстатокПерерасход.КоманднаяПанель);
		НовЭлКоманды.ИмяКоманды = "ЗаполнитьТаблицуВнесенияОстатка";
		НовЭлКоманды.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
		
		НовЭлКоманды = Элементы.Добавить("ЗаполнитьТаблицуВыдачиПерерасхода", Тип("КнопкаФормы"), Элементы.ОстатокПерерасход.КоманднаяПанель);
		НовЭлКоманды.ИмяКоманды = "ЗаполнитьТаблицуВыдачиПерерасхода";
		НовЭлКоманды.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
		
		НовЭлКоманды = Элементы.Добавить("ЗаполнитьТаблицуПолучено", Тип("КнопкаФормы"), Элементы.Получено.КоманднаяПанель);
		НовЭлКоманды.ИмяКоманды = "ЗаполнитьТаблицуПолучено";
		НовЭлКоманды.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
		
		ЭлементыДобавлены = Истина;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура АБК_ЗаполнитьТаблицуИзрасходованоПосле(Команда)   
	Если Объект["Израсходовано"].Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru='Перед заполнением будет очищена
			|табличная часть ""Израсходовано"".
			|
			|Продолжить и очистить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("АБК_ЗаполнитьТаблицуИзрасходованоПосле_Выбор", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстСообщения, РежимДиалогаВопрос.ДаНет, 20, КодВозвратаДиалога.Да, "Заполнить таблицу ""Израсходовано""", КодВозвратаДиалога.Нет);
	Иначе
		АБК_ЗаполнитьТаблицуИзрасходованоПослеНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АБК_ЗаполнитьТаблицуИзрасходованоПосле_Выбор(РезультатВыбора, ПараметрыОповещения) Экспорт
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		АБК_ЗаполнитьТаблицуИзрасходованоПослеНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура АБК_ЗаполнитьТаблицуИзрасходованоПослеНаСервере()  
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ИСТИНА КАК ПоДокументу,
	|	ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор КАК ПриходныйДокумент,
	|	ВЫБОР
	|		КОГДА ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт ЕСТЬ NULL
	|				ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|				ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = &ВалютаРуб
	|			ТОГДА &ВалютаРуб
	|		ИНАЧЕ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт
	|	КОНЕЦ КАК Валюта,
	|	СУММА(ВЫБОР
	|			КОГДА ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт ЕСТЬ NULL
	|					ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|					ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = &ВалютаРуб
	|				ТОГДА 0
	|			ИНАЧЕ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютнаяСуммаКт
	|		КОНЕЦ) КАК СуммаВВалюте,
	|	СУММА(ЖурналПроводокЕПСБУДвиженияССубконто.Сумма) КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.ЖурналПроводокЕПСБУ.ДвиженияССубконто(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Организация = &Организация
	|				И СчетКт В (&СчетаКт)
	|				И &УсловиеИФО
	|				И (Регистратор ССЫЛКА Документ.ПоступлениеМЗ
	|					ИЛИ Регистратор ССЫЛКА Документ.ПриходныйОрдерФондовый
	|					ИЛИ Регистратор ССЫЛКА Документ.ПоступлениеОС),
	|			,
	|			) КАК ЖурналПроводокЕПСБУДвиженияССубконто
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АвансовыйОтчет.Израсходовано КАК АвансовыйОтчетИзрасходовано
	|		ПО (АвансовыйОтчетИзрасходовано.ПриходныйДокумент = ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор)
	|ГДЕ
	|	ЖурналПроводокЕПСБУДвиженияССубконто.СубконтоКт1 = &Контрагент
	|	И (ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт ЕСТЬ NULL
	|			ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|				И &Валюта = &ВалютаРуб
	|			ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = &ВалютаРуб
	|			ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = &Валюта)
	|	И (АвансовыйОтчетИзрасходовано.Ссылка ЕСТЬ NULL
	|			ИЛИ АвансовыйОтчетИзрасходовано.Ссылка = &АвансовыйОтчет)
	|	И НЕ ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор В (&Выбранные)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор,
	|	ВЫБОР
	|		КОГДА ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт ЕСТЬ NULL
	|				ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|				ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = &ВалютаРуб
	|			ТОГДА &ВалютаРуб
	|		ИНАЧЕ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт
	|	КОНЕЦ");                                           
	
	
	МассивВыбранных = Новый Массив;
	
	ПараметрыЗаполнения = Новый Структура("НачалоПериода, КонецПериода, ИФО, Организация, Сотрудник, Валюта, МассивВыбранных, АвансовыйОтчет",
	НачалоДня(ПериодЗаполнения.ДатаНачала),
	КонецДня(ПериодЗаполнения.ДатаОкончания),
	Объект.ИФО,
	Объект.Организация,
	Объект.Сотрудник,
	Объект.ВалютаДокумента,
	МассивВыбранных,
	Объект.Ссылка);
	
	СчетаКт = БухгалтерскийУчетПовтИсп.ПолучитьМассивСчетов("208.00");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоИФО") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеИФО", "ИФО = &ИФО");   
		Запрос.УстановитьПараметр("ИФО", ПараметрыЗаполнения.ИФО);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеИФО", "ИСТИНА");   
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоПериода", ПараметрыЗаполнения.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", 	ПараметрыЗаполнения.КонецПериода);
	Запрос.УстановитьПараметр("Организация", 	ПараметрыЗаполнения.Организация);
	Запрос.УстановитьПараметр("Контрагент", 	ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыЗаполнения.Сотрудник, "Контрагент"));
	Запрос.УстановитьПараметр("ВалютаРуб", 	БухгалтерскийУчетПовтИсп.ВалютаРегламентированногоУчета());
	Запрос.УстановитьПараметр("Валюта", 		ПараметрыЗаполнения.Валюта);
	Запрос.УстановитьПараметр("СчетаКт", 		СчетаКт);
	Запрос.УстановитьПараметр("Выбранные", 	ПараметрыЗаполнения.МассивВыбранных);
	Запрос.УстановитьПараметр("АвансовыйОтчет",ПараметрыЗаполнения.АвансовыйОтчет);      
	
	Объект.Израсходовано.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ЭтаФорма.Модифицированность = Истина;
	
	ОбновитьДанныеОстаткаПерерасхода(, Истина);
	ОстатокПерерасходТекущегоАванса = СтрокаОстатокПерерасходТекущегоАванса(НезавершенныеРасчетыПоВалютам);

КонецПроцедуры

&НаКлиенте
Процедура АБК_ЗаполнитьТаблицуПолученоПосле(Команда)
	Если Объект["Получено"].Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru='Перед заполнением будет очищена
			|табличная часть ""Получено"".
			|
			|Продолжить и очистить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ЗаполнитьТаблицуПолучено_ОстаткаПерерасхода_Выбор", ЭтотОбъект, Новый Структура("ТребуемыйДокумент", "ДокументАванса"));
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстСообщения, РежимДиалогаВопрос.ДаНет, 20, КодВозвратаДиалога.Да, "Заполнить таблицу ""Получено""", КодВозвратаДиалога.Нет);
	Иначе
		ЗаполнитьТаблицуПолучено_ОстаткаПерерасхода("ДокументАванса");
	КонецЕсли;
КонецПроцедуры  

&НаКлиенте
Процедура АБК_ЗаполнитьТаблицуВыдачиПерерасходаПосле(Команда)   
	Если Объект["ОстатокПерерасход"].Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru='Перед заполнением будут очищены 
			|колонки табличной части по документам выдачи перерасхода.
			|
			|Продолжить и очистить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ЗаполнитьТаблицуПолучено_ОстаткаПерерасхода_Выбор", ЭтотОбъект, Новый Структура("ТребуемыйДокумент", "ДокументПерерасхода"));
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстСообщения, РежимДиалогаВопрос.ДаНет, 20, КодВозвратаДиалога.Да, "Заполнить колонки таблицы по документам выдачи перерасхода", КодВозвратаДиалога.Нет);
	Иначе
		ЗаполнитьТаблицуПолучено_ОстаткаПерерасхода("ДокументПерерасхода");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АБК_ЗаполнитьТаблицуВнесенияОстаткаПосле(Команда)  
	Если Объект["ОстатокПерерасход"].Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru='Перед заполнением будут очищены 
			|колонки табличной части по документам внесения остатка.
			|
			|Продолжить и очистить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ЗаполнитьТаблицуПолучено_ОстаткаПерерасхода_Выбор", ЭтотОбъект, Новый Структура("ТребуемыйДокумент", "ДокументОстатка"));
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстСообщения, РежимДиалогаВопрос.ДаНет, 20, КодВозвратаДиалога.Да, "Заполнить колонки таблицы по документам внесения остатка", КодВозвратаДиалога.Нет);
	Иначе
		ЗаполнитьТаблицуПолучено_ОстаткаПерерасхода("ДокументОстатка");
	КонецЕсли;
КонецПроцедуры      

&НаКлиенте
Процедура ЗаполнитьТаблицуПолучено_ОстаткаПерерасхода_Выбор(РезультатВыбора, ПараметрыОповещения) Экспорт
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		ЗаполнитьТаблицуПолучено_ОстаткаПерерасхода(ПараметрыОповещения.ТребуемыйДокумент);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПолучено_ОстаткаПерерасхода(ТребуемыйДокумент)    
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор КАК ##ТребуемыйДокумент,
	|	ВЫБОР
	|		КОГДА &Дт208
	|			ТОГДА ВЫБОР
	|					КОГДА ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт ЕСТЬ NULL
	|							ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|							ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = &ВалютаРуб
	|						ТОГДА &ВалютаРуб
	|					ИНАЧЕ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт ЕСТЬ NULL
	|						ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|						ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт = &ВалютаРуб
	|					ТОГДА &ВалютаРуб
	|				ИНАЧЕ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт
	|			КОНЕЦ
	|	КОНЕЦ КАК ##Валюта,
	|	СУММА(ВЫБОР
	|			КОГДА &Дт208
	|				ТОГДА ВЫБОР
	|						КОГДА ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт ЕСТЬ NULL
	|								ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|								ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = &ВалютаРуб
	|							ТОГДА ЖурналПроводокЕПСБУДвиженияССубконто.Сумма
	|						ИНАЧЕ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютнаяСуммаКт
	|					КОНЕЦ
	|			ИНАЧЕ ВЫБОР
	|					КОГДА ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт ЕСТЬ NULL
	|							ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|							ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт = &ВалютаРуб
	|						ТОГДА ЖурналПроводокЕПСБУДвиженияССубконто.Сумма
	|					ИНАЧЕ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютнаяСуммаДт
	|				КОНЕЦ
	|		КОНЕЦ) КАК ##Сумма
	|ИЗ
	|	РегистрБухгалтерии.ЖурналПроводокЕПСБУ.ДвиженияССубконто(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Организация = &Организация
	|				И СчетДт В (&СчетаДт)
	|				И СчетКт В (&СчетаКт)
	|				И Активность
	|				И НЕ Регистратор ССЫЛКА Документ.ЗакрытиеГодаТехнологическое
	|				И &УсловиеИФО,
	|			,
	|			) КАК ЖурналПроводокЕПСБУДвиженияССубконто
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АвансовыйОтчет.Получено КАК АвансовыйОтчетПолучено
	|		ПО ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор = АвансовыйОтчетПолучено.ДокументАванса
	|			И (АвансовыйОтчетПолучено.Ссылка.Сотрудник = &Сотрудник)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АвансовыйОтчет.ОстатокПерерасход КАК АвансовыйОтчетПерерасход
	|		ПО (АвансовыйОтчетПерерасход.ДокументПерерасхода = ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор)
	|			И (АвансовыйОтчетПерерасход.Ссылка.Сотрудник = &Сотрудник)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АвансовыйОтчет.ОстатокПерерасход КАК АвансовыйОтчетОстаток
	|		ПО (АвансовыйОтчетОстаток.ДокументОстатка = ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор)
	|			И (АвансовыйОтчетОстаток.Ссылка.Сотрудник = &Сотрудник)
	|ГДЕ
	|	(&Дт208
	|				И ЖурналПроводокЕПСБУДвиженияССубконто.СубконтоДт1 = &Контрагент
	|			ИЛИ НЕ &Дт208
	|				И ЖурналПроводокЕПСБУДвиженияССубконто.СубконтоКт1 = &Контрагент)
	|	И (&Дт208
	|				И (ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт ЕСТЬ NULL
	|					ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|						И &Валюта = &ВалютаРуб
	|					ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = &ВалютаРуб
	|					ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = &Валюта)
	|			ИЛИ НЕ &Дт208
	|				И (ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт ЕСТЬ NULL
	|					ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|						И &Валюта = &ВалютаРуб
	|					ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт = &ВалютаРуб
	|					ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт = &Валюта))
	|	И (АвансовыйОтчетПолучено.Ссылка ЕСТЬ NULL
	|			ИЛИ АвансовыйОтчетПолучено.Ссылка = &АвансовыйОтчет)
	|	И (АвансовыйОтчетПерерасход.Ссылка ЕСТЬ NULL
	|			ИЛИ АвансовыйОтчетПерерасход.Ссылка = &АвансовыйОтчет)
	|	И (АвансовыйОтчетОстаток.Ссылка ЕСТЬ NULL
	|			ИЛИ АвансовыйОтчетОстаток.Ссылка = &АвансовыйОтчет)
	|	И НЕ ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор В (&ИсключитьДокументы)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор,
	|	ВЫБОР
	|		КОГДА &Дт208
	|			ТОГДА ВЫБОР
	|					КОГДА ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт ЕСТЬ NULL
	|							ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|							ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт = &ВалютаРуб
	|						ТОГДА &ВалютаРуб
	|					ИНАЧЕ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаКт
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт ЕСТЬ NULL
	|						ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|						ИЛИ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт = &ВалютаРуб
	|					ТОГДА &ВалютаРуб
	|				ИНАЧЕ ЖурналПроводокЕПСБУДвиженияССубконто.ВалютаДт
	|			КОНЕЦ
	|	КОНЕЦ");          
	
	ИсключитьДокументы = Новый Массив;    
	
	Если ТребуемыйДокумент = "ДокументПерерасхода" Тогда
		Для Каждого СтрокаПолучено Из Объект.Получено Цикл
			ИсключитьДокументы.Добавить(СтрокаПолучено.ДокументАванса);
		КонецЦикла;   
	ИначеЕсли ТребуемыйДокумент = "ДокументАванса" Тогда
		Для Каждого СтрокаОстатокПерерасход Из Объект.ОстатокПерерасход Цикл
			ИсключитьДокументы.Добавить(СтрокаОстатокПерерасход.ДокументПерерасхода);
		КонецЦикла;    
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура("НачалоПериода, КонецПериода, ИФО, Организация, Сотрудник, Валюта, ИсключитьДокументы, АвансовыйОтчет, Кт208",
	НачалоДня(ПериодЗаполнения.ДатаНачала),
	КонецДня(ПериодЗаполнения.ДатаОкончания),
	Объект.ИФО,
	Объект.Организация,
	Объект.Сотрудник,
	Объект.ВалютаДокумента,
	ИсключитьДокументы,
	Объект.Ссылка,
	ТребуемыйДокумент = "ДокументОстатка");
	
	Если ПараметрыЗаполнения.Кт208 Тогда
		СчетаДт = БухгалтерскийУчет.СписокСчетов("201.00,210.00,304.00,000");
		СчетаКт = БухгалтерскийУчет.СписокСчетов("208.00");
	Иначе
		СчетаДт = БухгалтерскийУчет.СписокСчетов("208.00");
		СчетаКт = БухгалтерскийУчет.СписокСчетов("201.00,210.00,304.00,000");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоИФО") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеИФО", "ИФО = &ИФО");   
		Запрос.УстановитьПараметр("ИФО", ПараметрыЗаполнения.ИФО);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеИФО", "ИСТИНА");   
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыЗаполнения.НачалоПериода)
		И ЗначениеЗаполнено(ПараметрыЗаполнения.КонецПериода)
		И ПараметрыЗаполнения.КонецПериода < ПараметрыЗаполнения.НачалоПериода Тогда
		ПараметрыЗаполнения.КонецПериода = Дата(1,1,1);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоПериода", 		ПараметрыЗаполнения.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", 		ПараметрыЗаполнения.КонецПериода);
	Запрос.УстановитьПараметр("Организация", 		ПараметрыЗаполнения.Организация);
	Запрос.УстановитьПараметр("Сотрудник", 			ПараметрыЗаполнения.Сотрудник);
	Запрос.УстановитьПараметр("Контрагент", 		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыЗаполнения.Сотрудник, "Контрагент"));
	Запрос.УстановитьПараметр("ВалютаРуб", 			БухгалтерскийУчетПовтИсп.ВалютаРегламентированногоУчета());
	Запрос.УстановитьПараметр("Валюта", 			ПараметрыЗаполнения.Валюта);
	Запрос.УстановитьПараметр("Дт208", 				НЕ ПараметрыЗаполнения.Кт208);
	Запрос.УстановитьПараметр("СчетаДт", 			СчетаДт);
	Запрос.УстановитьПараметр("СчетаКт", 			СчетаКт);
	Запрос.УстановитьПараметр("ИсключитьДокументы",	ПараметрыЗаполнения.ИсключитьДокументы);
	Запрос.УстановитьПараметр("АвансовыйОтчет",		ПараметрыЗаполнения.АвансовыйОтчет);     
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "##ТребуемыйДокумент", ТребуемыйДокумент);
	
	Если ТребуемыйДокумент = "ДокументАванса" Тогда     
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "##Валюта", "Валюта");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "##Сумма", "Сумма");
		Объект.Получено.Загрузить(Запрос.Выполнить().Выгрузить()); 
	Иначе             
		КолонкиВыгрузки = "";
		КолонкиПроверки = "";
		
		Если ТребуемыйДокумент = "ДокументПерерасхода" Тогда 
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "##Валюта", "ВалютаПерерасхода");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "##Сумма", "СуммаПерерасхода");
			КолонкиВыгрузки = "ДокументОстатка, СуммаОстатка, ВалютаОстатка";	
			КолонкиПроверки = "ДокументОстатка";
		ИначеЕсли ТребуемыйДокумент = "ДокументОстатка" Тогда                  
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "##Валюта", "ВалютаОстатка");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "##Сумма", "СуммаОстатка");
			КолонкиВыгрузки = "ДокументПерерасхода, СуммаПерерасхода, ВалютаПерерасхода";  
			КолонкиПроверки = "ДокументПерерасхода";
		Иначе
			Возврат;
		КонецЕсли; 
		
		ТаблицаЗагрузки = Объект.ОстатокПерерасход.Выгрузить(,КолонкиВыгрузки);
		УдалитьСтрокиПоПустымКолонкам(ТаблицаЗагрузки, КолонкиПроверки);
		
		Объект.ОстатокПерерасход.Загрузить(ТаблицаЗагрузки);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Объект.ОстатокПерерасход.Добавить(), Выборка);		
		КонецЦикла;
	Конецесли;
	
	ЭтаФорма.Модифицированность = Истина;   
	
	ОбновитьДанныеОстаткаПерерасхода(, Истина); 
	ОстатокПерерасходТекущегоАванса = СтрокаОстатокПерерасходТекущегоАванса(НезавершенныеРасчетыПоВалютам);
	
КонецПроцедуры  

&НаСервере
Процедура УдалитьСтрокиПоПустымКолонкам(ТаблицаНаПроверку, ПроверяемыеКолонки = "")    
	МассивДляУдаления = Новый Массив; 
	
	МассивПроверяемыхКолонок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
	СтрЗаменить(ПроверяемыеКолонки, " ", ""), ",", , Истина);  
	
	Если НЕ МассивПроверяемыхКолонок.Количество() Тогда   
		Для Каждого Колонка из ТаблицаНаПроверку.Колонки Цикл
			МассивПроверяемыхКолонок.Добавить(Колонка.Имя);			
		КонецЦикла;     
	КонецЕсли;                  
	
	Для Каждого Стр из ТаблицаНаПроверку Цикл
		Для Каждого ПроверяемаяКолонка из МассивПроверяемыхКолонок Цикл
			Если НЕ ЗначениеЗаполнено(Стр[ПроверяемаяКолонка]) Тогда
				МассивДляУдаления.Добавить(Стр);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;  
	
	Для Каждого Эл из МассивДляУдаления Цикл
		ТаблицаНаПроверку.Удалить(Эл);	
	КонецЦикла;
КонецПроцедуры




