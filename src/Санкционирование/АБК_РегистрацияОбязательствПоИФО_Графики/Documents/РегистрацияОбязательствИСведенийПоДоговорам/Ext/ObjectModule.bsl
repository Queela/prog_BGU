﻿
&Перед("ОбработкаПроверкиЗаполнения")
Процедура АБК_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемые = Новый Массив;
	МассивНепроверяемые.Добавить("ИФО");
	МассивНепроверяемые.Добавить("ЛицевойСчет");
	
	Для Каждого Элемент Из МассивНепроверяемые Цикл
		Индекс = ПроверяемыеРеквизиты.Найти(Элемент);
		Если Индекс <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(Индекс);	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&ИзменениеИКонтроль("ЗаполнитьПоДоговору")
Процедура АБК_ЗаполнитьПоДоговору(Договор, ЗаполнятьДанныеТабЧастей, ОснованиеЗаполнения)
	Перем Запрос, ТекстЗапроса;
	Перем Результат;
	
	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ
	|	Договоры.Организация КАК Организация,
	|	Договоры.Контрагент КАК Контрагент,
	|	Договоры.СчетКонтрагента КАК СчетКонтрагента,
	|	Договоры.Договор,
	|	ВЫБОР
	|		КОГДА Договоры.УчетПредметаДоговора
	|			ТОГДА ВЫБОР
	|					КОГДА Договоры.ВидДоговора <> ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.ИноеОбязательство)
	|							И ЕСТЬNULL(СрокиСуммы.Регистратор, 0) <> 0
	|						ТОГДА ВЫБОР
	|								КОГДА (СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательство)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоИзменения)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоПеререгистрация))
	|										И Договоры.РезультатЗавершенияКонкурсныхПроцедур = 1
	|									ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринятоеОбязательствоКонкурсныеПроцедуры)
	|								КОГДА (СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательство)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоИзменения)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоПеререгистрация))
	|										И Договоры.РезультатЗавершенияКонкурсныхПроцедур = 2
	|									ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ОтказОтДоговораКонкурсныеПроцедуры)
	| //Изменение принимаемого
	|								КОГДА (СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательство)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоИзменения)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоПеререгистрация))
	|										И НЕ Договоры.ПризнакЗавершенияКонкурсныхПроцедур
	|									ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоИзменения)
	| //Изменение принимаемого
	|								ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ЗаявкаНаИзменениеОбязательстваУчетПредмета)
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА Договоры.ЗаключаетсяПоРезультатамКонкурсныхПроцедур
	|									И Договоры.РезультатЗавершенияКонкурсныхПроцедур = 1
	|								ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринятоеОбязательствоКонкурсныеПроцедуры)
	|							КОГДА Договоры.ЗаключаетсяПоРезультатамКонкурсныхПроцедур
	|									И (Договоры.РезультатЗавершенияКонкурсныхПроцедур = 0
	|										ИЛИ Договоры.РезультатЗавершенияКонкурсныхПроцедур = 2)
	|								ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательство)
	|							ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринятоеОбязательствоУчетПредмета)
	|						КОНЕЦ
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	#Вставка
	|				КОГДА ЕСТЬNULL(СрокиСуммы.Регистратор, 0) <> 0
	|				И	Договоры.ВидДоговора <> ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.ИноеОбязательство)
	#КонецВставки
	#Удаление
	|				КОГДА ЕСТЬNULL(СрокиСуммы.Регистратор, 0) <> 0
	#КонецУдаления
	|					ТОГДА ВЫБОР
	|								КОГДА (СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательство)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоИзменения)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоПеререгистрация))
	|										И Договоры.РезультатЗавершенияКонкурсныхПроцедур = 1
	|									ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринятоеОбязательствоКонкурсныеПроцедуры)
	|								КОГДА (СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательство)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоИзменения)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоПеререгистрация))
	|										И Договоры.РезультатЗавершенияКонкурсныхПроцедур = 2
	|									ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ОтказОтДоговораКонкурсныеПроцедуры)
	| //Изменение принимаемого
	|								КОГДА (СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательство)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоИзменения)
	|                                    ИЛИ СрокиСуммы.ВидОбязательства = ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоПеререгистрация))
	|										И НЕ Договоры.ПризнакЗавершенияКонкурсныхПроцедур
	|									ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоИзменения)
	| //Изменение принимаемого
	|								ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ЗаявкаНаИзменениеОбязательства)
	|							КОНЕЦ
	|		ИНАЧЕ ВЫБОР 
	|				КОГДА Договоры.ЗаключаетсяПоРезультатамКонкурсныхПроцедур
	|					И (Договоры.РезультатЗавершенияКонкурсныхПроцедур = 0
	|					ИЛИ Договоры.РезультатЗавершенияКонкурсныхПроцедур = 2)
	|					ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринимаемоеОбязательство)
	|				ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПринятыхОбязательств.ПринятоеОбязательство)	
	|			  КОНЕЦ
	|		КОНЕЦ
	|	КОНЕЦ КАК ВидОбязательства,
	|	СрокиСуммы.НачалоДействия,
	|	СрокиСуммы.НачалоДействия КАК НачалоДействияДоИзменений,
	|	СрокиСуммы.ОкончаниеДействия,
	|	СрокиСуммы.ОкончаниеДействия КАК ОкончаниеДействияДоИзменений,
	|	СрокиСуммы.ВалютаРасчетов КАК ВалютаДокумента,
	|	СрокиСуммы.АвансПроцентом,
	|	СрокиСуммы.СуммаАванса,
	|	СрокиСуммы.Сумма,
	|	СрокиСуммы.СуммаВВалюте,
	|	СрокиСуммы.КурсРасчетов КАК Курс,
	|	СрокиСуммы.КратностьРасчетов КАК Кратность,
	|	ЕСТЬNULL(СрокиСуммы.ЛицевойСчет, Договоры.ОтдельныйСчетДляРасчетовПоГОЗ) КАК ЛицевойСчет,
	|	СрокиСуммы.ОрганКазначейства КАК ОрганКазначейства,
	|	СрокиСуммы.ИФО КАК ИФО,
	|	ВЫБОР
	|		КОГДА Договоры.ВидДоговора <> ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.ИноеОбязательство)
	|			ТОГДА СрокиСуммы.Регистратор
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Основание,
	|	Договоры.УчетПредметаДоговора,
	|	СрокиСуммы.СрокИсполнения,
	|	СрокиСуммы.СрокИсполнения КАК СрокИсполненияДоИзменений,
	|	Договоры.ВидДоговора,
	|	ВЫБОР
	|		КОГДА СрокиСуммы.Регистратор ССЫЛКА Документ.РегистрацияОбязательствИСведенийПоДоговорам
	|			ТОГДА СрокиСуммы.Регистратор.РеквизитыЛицевогоСчета
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.РеквизитыЛицевыхСчетов.ПустаяСсылка)
	|	КОНЕЦ КАК РеквизитыЛицевогоСчета,
	|	ВЫБОР
	|		КОГДА СрокиСуммы.Регистратор ССЫЛКА Документ.РегистрацияОбязательствИСведенийПоДоговорам
	|			ТОГДА ЕстьNULL(СрокиСуммы.Регистратор.НомерИзменения, -1) + 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НомерИзменения
	|ИЗ
	|	(ВЫБРАТЬ
	|		Договоры.Ссылка КАК Договор,
	|		Договоры.Организация КАК Организация,
	|		Договоры.Контрагент КАК Контрагент,
	|		Договоры.СчетКонтрагента КАК СчетКонтрагента,
	|		Договоры.ВидДоговора КАК ВидДоговора,
	|		Договоры.УчетПредметаДоговора КАК УчетПредметаДоговора,
	|		Договоры.ЗаключаетсяПоРезультатамКонкурсныхПроцедур КАК ЗаключаетсяПоРезультатамКонкурсныхПроцедур,
	|		Договоры.РезультатЗавершенияКонкурсныхПроцедур КАК РезультатЗавершенияКонкурсныхПроцедур,
	|		Договоры.ПризнакЗавершенияКонкурсныхПроцедур КАК ПризнакЗавершенияКонкурсныхПроцедур,
	|		Договоры.ОтдельныйСчетДляРасчетовПоГОЗ КАК ОтдельныйСчетДляРасчетовПоГОЗ
	|	ИЗ
	|		Справочник.Договоры КАК Договоры
	|	ГДЕ
	|		Договоры.Ссылка = &Договор) КАК Договоры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиИсполненияИСуммыОбязательств.СрезПоследних(
	|				&Период,
	|				Обязательство = &Договор
	|					И &УсловиеРегистратор) КАК СрокиСуммы
	|		ПО Договоры.Договор = СрокиСуммы.Обязательство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПФОСрезПоследних.КлючАналитики.КФО КАК КФО,
	#Вставка
	|	ПФОСрезПоследних.ИФО КАК ИФО,
	#КонецВставки
	|	ПФОСрезПоследних.КлючАналитики.КПС КАК КПС,
	|	ПФОСрезПоследних.КлючАналитики.КЭК КАК КЭК,
	|	ПФОСрезПоследних.КлючАналитики.ОбъектФАИП КАК ОбъектФАИП,
	|	ПФОСрезПоследних.КлючАналитики.Подразделение КАК Подразделение,
	|	ПФОСрезПоследних.КлючАналитики.Номенклатура КАК Номенклатура,
	|	ПФОСрезПоследних.КлючАналитики.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ПФОСрезПоследних.КлючАналитики.ПериодПлана КАК ПериодПлана,
	|	ПФОСрезПоследних.КлючАналитики.РазделЛицевогоСчета КАК РазделЛицевогоСчета,
	|	ПФОСрезПоследних.КлючАналитики.КодЦели КАК КодЦели,
	|	ПФОСрезПоследних.КлючАналитики.КодМероприятия КАК КодМероприятия,
	|	ПФОСрезПоследних.КлючАналитики.ДопКлассификация КАК ДопКлассификация,
	|	ПФОСрезПоследних.Количество,
	|	ПФОСрезПоследних.Сумма,
	|	ПФОСрезПоследних.СуммаВВалюте,
	|	ПФОСрезПоследних.СуммаВВалютеБезусловная,
	|	ПФОСрезПоследних.СуммаИсполнено,
	|	ПФОСрезПоследних.СуммаИсполненоБезусловно,
	|	ИСТИНА КАК ЗапретИзменения,
	|	ПФОСрезПоследних.ОКП КАК ОКП
	|ИЗ
	|	РегистрСведений.ПланФинансированияОбязательств.СрезПоследних(
	|			&Период,
	|			Обязательство = &Договор
	|				И &УсловиеРегистратор) КАК ПФОСрезПоследних
	|ГДЕ
	|	(ПФОСрезПоследних.Количество <> 0
	|			ИЛИ ПФОСрезПоследних.Сумма <> 0
	|			ИЛИ ПФОСрезПоследних.СуммаВВалюте <> 0
	|			ИЛИ ПФОСрезПоследних.СуммаВВалютеБезусловная <> 0
	|			ИЛИ ПФОСрезПоследних.СуммаИсполнено <> 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПФОСрезПоследних.КлючАналитики.ОбъектФАИП,
	|	ПФОСрезПоследних.КлючАналитики.ПериодПлана.ДатаНачала,
	|	КФО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоговорыКонтрагенты.Контрагент,
	|	ДоговорыКонтрагенты.СчетКонтрагента
	|ИЗ
	|	Справочник.Договоры.Контрагенты КАК ДоговорыКонтрагенты
	|ГДЕ
	|	ДоговорыКонтрагенты.Ссылка = &Договор";
	   
	Запрос.УстановитьПараметр("Период", ?(ЭтоНовый(), ТекущаяДата(), Дата));
	Запрос.УстановитьПараметр("Договор", Договор);
	
	Если ТипЗнч(ОснованиеЗаполнения) = Тип("ДокументСсылка.РегистрацияОбязательствИСведенийПоДоговорам") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеРегистратор", "Регистратор = &Регистратор");
		Запрос.УстановитьПараметр("Регистратор", ОснованиеЗаполнения);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеРегистратор", "Регистратор <> &Регистратор");
		Запрос.УстановитьПараметр("Регистратор", Ссылка);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.ВыполнитьПакет();
	Контрагенты.Очистить();
	
	// Заполним данные шапки
	СтруктураШапки = Результат[0].Выбрать();
	СтруктураШапки.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураШапки);
	
	СписокКонтрагентов = Результат[2].Выбрать();
	Пока СписокКонтрагентов.Следующий() Цикл
		НовКонтрагент = Контрагенты.Добавить();
		ЗаполнитьЗначенияСвойств(НовКонтрагент, СписокКонтрагентов);
	КонецЦикла;
	
	// Заполним данные в ТЧ
	ВедетсяУчетОбязательств = УчетРасчетовКлиентСервер.ВедетсяУчетОбязательств(СтруктураШапки.ВидДоговора);
	Если ВедетсяУчетОбязательств
	 И  (ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ЗаявкаНаИзменениеОбязательства 
	 ИЛИ ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ЗаявкаНаИзменениеОбязательстваУчетПредмета 
	 ИЛИ ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ПринятоеОбязательствоКонкурсныеПроцедуры 
	 ИЛИ ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ОтказОтДоговораКонкурсныеПроцедуры 
	 ИЛИ ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ПринимаемоеОбязательствоИзменения) Тогда
	 
	    РасшифровкаОбязательстваБюджет.Очистить();
		РасшифровкаОбязательстваВнебюджет.Очистить();
	 
	 	БюджетВнебюджетПоКФО = РаботаСОбязательствамиПовтИсп.ПолучитьБюджетВнебюджетПоКФО();	
		ВыборкаДанных = Результат[1].Выбрать();
		
		Пока ВыборкаДанных.Следующий() Цикл
			
			ИмяТЧ = БюджетВнебюджетПоКФО[ВыборкаДанных.КФО];
			
			Если НЕ ПустаяСтрока(ИмяТЧ) Тогда
				
				ИмяТЧ = "РасшифровкаОбязательства" + ИмяТЧ;
				НоваяСтрока = ЭтотОбъект[ИмяТЧ].Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДанных);
				
				Если ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ОтказОтДоговораКонкурсныеПроцедуры Тогда
					// сторно всех показателей
					НоваяСтрока.Количество 				= 0;
					НоваяСтрока.Сумма 					= 0;
					НоваяСтрока.СуммаВВалюте  			= 0;     
					НоваяСтрока.СуммаВВалютеБезусловная = 0;
				КонецЕсли;
			КонецЕсли;                                                                                  
		КонецЦикла; 
	КонецЕсли; 
	
	КонтрольИсполненияДоговоров.ЗаполнитьГрафикиИсполненияПоДоговору(ЭтотОбъект, Договор, ОснованиеЗаполнения);
	
	Если ВалютаДокумента.Пустая() Тогда
		ВалютаДокумента = ОбщегоНазначенияБГУПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	КонецЕсли; 
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ?(ЭтоНовый(), ТекущаяДата(), Дата));
	Курс = СтруктураКурса.Курс;
	Кратность = СтруктураКурса.Кратность;
	
КонецПроцедуры

&ИзменениеИКонтроль("ПроверитьДублиСтрок")
Процедура АБК_ПроверитьДублиСтрок(Отказ)

	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ
	|	ТаблицаБюджет.НомерСтроки,
	|	ТаблицаБюджет.ПериодПлана,
	|	ТаблицаБюджет.КФО,
	#Вставка
	|	ТаблицаБюджет.ИФО,
	#КонецВставки
	|	ТаблицаБюджет.КПС,
	|	ТаблицаБюджет.КЭК,
	|	ТаблицаБюджет.ОбъектФАИП,
	|	ТаблицаБюджет.Подразделение,
	|	ТаблицаБюджет.РазделЛицевогоСчета,
	|	ТаблицаБюджет.Номенклатура,
	|	ТаблицаБюджет.ЕдиницаИзмерения,
	|	ТаблицаБюджет.КодЦели,
	|	ТаблицаБюджет.КодМероприятия,
	|	ТаблицаБюджет.ДопКлассификация,
	|	ТаблицаБюджет.ОКП
	|ПОМЕСТИТЬ ТаблицаБюджет
	|ИЗ
	|	&ТаблицаДокументаБюджет КАК ТаблицаБюджет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВнебюджет.НомерСтроки,
	|	ТаблицаВнебюджет.ПериодПлана,
	|	ТаблицаВнебюджет.КФО,
	#Вставка
	|	ТаблицаВнебюджет.ИФО,
	#КонецВставки
	|	ТаблицаВнебюджет.КПС,
	|	ТаблицаВнебюджет.КЭК,
	|	ТаблицаВнебюджет.ОбъектФАИП,
	|	ТаблицаВнебюджет.Подразделение,
	|	ТаблицаВнебюджет.РазделЛицевогоСчета,
	|	ТаблицаВнебюджет.Номенклатура,
	|	ТаблицаВнебюджет.ЕдиницаИзмерения,
	|	ТаблицаВнебюджет.КодЦели,
	|	ТаблицаВнебюджет.КодМероприятия,
	|	ТаблицаВнебюджет.ДопКлассификация,
	|	ТаблицаВнебюджет.ОКП
	|ПОМЕСТИТЬ ТаблицаВнебюджет
	|ИЗ
	|	&ТаблицаДокументаВнебюджет КАК ТаблицаВнебюджет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаБюджет.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаБюджет.ПериодПлана,
	|	ТаблицаБюджет.КФО,
	#Вставка
	|	ТаблицаБюджет.ИФО,
	#КонецВставки
	|	ТаблицаБюджет.КПС,
	|	ТаблицаБюджет.КЭК,
	|	ТаблицаБюджет.ОбъектФАИП,
	|	ТаблицаБюджет.Подразделение,
	|	ТаблицаБюджет.РазделЛицевогоСчета,
	|	ТаблицаБюджет.Номенклатура,
	|	ТаблицаБюджет.ЕдиницаИзмерения,
	|	ТаблицаБюджет.КодЦели,
	|	ТаблицаБюджет.КодМероприятия,
	|	ТаблицаБюджет.ДопКлассификация,
	|	ТаблицаБюджет.ОКП
	|ИЗ
	|	ТаблицаБюджет КАК ТаблицаБюджет
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаБюджет.ПериодПлана,
	|	ТаблицаБюджет.КФО,
	#Вставка
	|	ТаблицаБюджет.ИФО,
	#КонецВставки
	|	ТаблицаБюджет.КПС,
	|	ТаблицаБюджет.КЭК,
	|	ТаблицаБюджет.ОбъектФАИП,
	|	ТаблицаБюджет.Подразделение,
	|	ТаблицаБюджет.РазделЛицевогоСчета,
	|	ТаблицаБюджет.Номенклатура,
	|	ТаблицаБюджет.ЕдиницаИзмерения,
	|	ТаблицаБюджет.КодЦели,
	|	ТаблицаБюджет.КодМероприятия,
	|	ТаблицаБюджет.ДопКлассификация,
	|	ТаблицаБюджет.ОКП
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаВнебюджет.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаВнебюджет.ПериодПлана,
	|	ТаблицаВнебюджет.КФО,
	#Вставка
	|	ТаблицаВнебюджет.ИФО,
	#КонецВставки
	|	ТаблицаВнебюджет.КПС,
	|	ТаблицаВнебюджет.КЭК,
	|	ТаблицаВнебюджет.ОбъектФАИП,
	|	ТаблицаВнебюджет.Подразделение,
	|	ТаблицаВнебюджет.РазделЛицевогоСчета,
	|	ТаблицаВнебюджет.Номенклатура,
	|	ТаблицаВнебюджет.ЕдиницаИзмерения,
	|	ТаблицаВнебюджет.КодЦели,
	|	ТаблицаВнебюджет.КодМероприятия,
	|	ТаблицаВнебюджет.ДопКлассификация,
	|	ТаблицаВнебюджет.ОКП
	|ИЗ
	|	ТаблицаВнебюджет КАК ТаблицаВнебюджет
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаВнебюджет.ЕдиницаИзмерения,
	|	ТаблицаВнебюджет.КПС,
	|	ТаблицаВнебюджет.КФО,
	#Вставка
	|	ТаблицаВнебюджет.ИФО,
	#КонецВставки
	|	ТаблицаВнебюджет.РазделЛицевогоСчета,
	|	ТаблицаВнебюджет.ОКП,
	|	ТаблицаВнебюджет.Номенклатура,
	|	ТаблицаВнебюджет.КЭК,
	|	ТаблицаВнебюджет.ОбъектФАИП,
	|	ТаблицаВнебюджет.Подразделение,
	|	ТаблицаВнебюджет.КодЦели,
	|	ТаблицаВнебюджет.КодМероприятия,
	|	ТаблицаВнебюджет.ДопКлассификация,
	|	ТаблицаВнебюджет.ПериодПлана
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) > 1";
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ТаблицаДокументаБюджет", РасшифровкаОбязательстваБюджет.Выгрузить());
	Запрос.УстановитьПараметр("ТаблицаДокументаВнебюджет", РасшифровкаОбязательстваВнебюджет.Выгрузить());

	МассивРезультатов = Запрос.ВыполнитьПакет();
	ВыборкаБюджет = МассивРезультатов[2].Выбрать();
	ВыборкаВнебюджет = МассивРезультатов[3].Выбрать();

	ТекстОшибки = "";
	Если ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ПринятоеОбязательствоУчетПредмета 
		ИЛИ ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ЗаявкаНаИзменениеОбязательстваУчетПредмета
		ИЛИ ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ЗаявкаНаПеререгистрациюОбязательстваУчетПредмета 
		ИЛИ (ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ПринимаемоеОбязательство И Договор.УчетПредметаДоговора) Тогда

		ТекстОшибки = НСтр("ru = 'Аналитика %2, %3, %4, %5, %6, %7, %8, %9, %10, %11, %12, %13, %14   повторяется в табличной части %1 средств'");	

	ИначеЕсли ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ПринятоеОбязательство
		ИЛИ ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ЗаявкаНаИзменениеОбязательства
		ИЛИ ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ЗаявкаНаПеререгистрациюОбязательства 
		ИЛИ ВидОбязательства = Перечисления.ВидыПринятыхОбязательств.ПринимаемоеОбязательство Тогда

		ТекстОшибки = НСтр("ru = 'Аналитика %2, %3, %4, %5, %6, %7, %8, %9, %10, %11  повторяется в табличной части %1 средств'");

	КонецЕсли;

	Пока ВыборкаБюджет.Следующий() Цикл

		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить("бюджетных");

		Если ЗначениеЗаполнено(ВыборкаБюджет.ОбъектФАИП) Тогда
			МассивПараметров.Добавить(ВыборкаБюджет.ОбъектФАИП);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %2,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли; 

		МассивПараметров.Добавить(ВыборкаБюджет.ПериодПлана);                   
		МассивПараметров.Добавить(ВыборкаБюджет.КФО);
		МассивПараметров.Добавить(ВыборкаБюджет.КПС);
		МассивПараметров.Добавить(ВыборкаБюджет.КЭК);
		МассивПараметров.Добавить(ВыборкаБюджет.РазделЛицевогоСчета);

		Если ЗначениеЗаполнено(ВыборкаБюджет.КодЦели) Тогда
			МассивПараметров.Добавить(ВыборкаБюджет.КодЦели);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %8,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли; 

		Если ЗначениеЗаполнено(ВыборкаБюджет.КодМероприятия) Тогда
			МассивПараметров.Добавить(ВыборкаБюджет.КодМероприятия);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %9,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли; 

		Если ЗначениеЗаполнено(ВыборкаБюджет.ДопКлассификация) Тогда
			МассивПараметров.Добавить(ВыборкаБюджет.ДопКлассификация);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %10,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли;

		Если ЗначениеЗаполнено(ВыборкаБюджет.Подразделение) Тогда
			МассивПараметров.Добавить(ВыборкаБюджет.Подразделение);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %11,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли;

		МассивПараметров.Добавить(ВыборкаБюджет.Номенклатура);
		МассивПараметров.Добавить(ВыборкаБюджет.ЕдиницаИзмерения);
		МассивПараметров.Добавить(ВыборкаБюджет.ОКП);

		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(ТекстОшибки, МассивПараметров);
		ОбщегоНазначения.СообщитьПользователю(Текст, ЭтотОбъект, "РасшифровкаОбязательстваБюджет[" + (ВыборкаБюджет.НомерСтроки - 1) + "].ПериодПлана",, Отказ);

	КонецЦикла;

	Пока ВыборкаВнебюджет.Следующий() Цикл

		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить("внебюджетных");

		Если ЗначениеЗаполнено(ВыборкаВнебюджет.ОбъектФАИП) Тогда
			МассивПараметров.Добавить(ВыборкаВнебюджет.ОбъектФАИП);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %2,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли; 

		МассивПараметров.Добавить(ВыборкаВнебюджет.ПериодПлана);
		МассивПараметров.Добавить(ВыборкаВнебюджет.КФО);
		МассивПараметров.Добавить(ВыборкаВнебюджет.КПС);
		МассивПараметров.Добавить(ВыборкаВнебюджет.КЭК);

		Если ЗначениеЗаполнено(ВыборкаВнебюджет.РазделЛицевогоСчета) Тогда 
			МассивПараметров.Добавить(ВыборкаВнебюджет.РазделЛицевогоСчета);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %7,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли;	

		Если ЗначениеЗаполнено(ВыборкаВнебюджет.КодЦели) Тогда
			МассивПараметров.Добавить(ВыборкаВнебюджет.КодЦели);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %8,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли; 

		Если ЗначениеЗаполнено(ВыборкаВнебюджет.КодМероприятия) Тогда
			МассивПараметров.Добавить(ВыборкаВнебюджет.КодМероприятия);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %9,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли; 

		Если ЗначениеЗаполнено(ВыборкаВнебюджет.ДопКлассификация) Тогда
			МассивПараметров.Добавить(ВыборкаВнебюджет.ДопКлассификация);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %10,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли;

		Если ЗначениеЗаполнено(ВыборкаВнебюджет.Подразделение) Тогда
			МассивПараметров.Добавить(ВыборкаВнебюджет.Подразделение);
		Иначе
			ТекстОшибки = СтрЗаменить(ТекстОшибки, " %11,", "");
			МассивПараметров.Добавить(Неопределено);
		КонецЕсли;

		МассивПараметров.Добавить(ВыборкаВнебюджет.Номенклатура);
		МассивПараметров.Добавить(ВыборкаВнебюджет.ЕдиницаИзмерения);
		МассивПараметров.Добавить(ВыборкаВнебюджет.ОКП);

		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(ТекстОшибки, МассивПараметров);
		ОбщегоНазначения.СообщитьПользователю(Текст, ЭтотОбъект, "РасшифровкаОбязательстваВнебюджет[" + (ВыборкаВнебюджет.НомерСтроки - 1) + "].ПериодПлана",, Отказ);

	КонецЦикла;


КонецПроцедуры

&ИзменениеИКонтроль("ВыполнитьПроверкуЗаявкиНаИзменение")
Процедура АБК_ВыполнитьПроверкуЗаявкиНаИзменение(СтруктураКорректировки, Отказ)

	// В этом случае проверяется только корректность аналитики - не изменяемая аналитика должна совпадать с аналитикой до изменения
	// Документ может быть создан после перегистрации - проверяются строки с годом перода не меньшим, чем год даты документа 

	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ
	|	Бюджет.ОбъектФАИП,
	|	Бюджет.Подразделение,
	|	Бюджет.КФО,
	#Вставка
	|	Бюджет.ИФО,
	#КонецВставки
	|	Бюджет.КПС,
	|	Бюджет.КЭК,
	|	Бюджет.Номенклатура,
	|	Бюджет.ЕдиницаИзмерения,
	|	Бюджет.ПериодПлана,
	|	Бюджет.РазделЛицевогоСчета,
	|	Бюджет.КодЦели,
	|	Бюджет.КодМероприятия,
	|	Бюджет.ДопКлассификация,
	|	Бюджет.ОКП,
	|	Бюджет.ЗапретИзменения
	|ПОМЕСТИТЬ ДокументБюджет
	|ИЗ
	|	&ТаблицаДокументаБюджет КАК Бюджет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Внебюджет.ОбъектФАИП,
	|	Внебюджет.Подразделение,
	|	Внебюджет.КФО,
	#Вставка
	|	Внебюджет.ИФО,
	#КонецВставки
	|	Внебюджет.КПС,
	|	Внебюджет.КЭК,
	|	Внебюджет.Номенклатура,
	|	Внебюджет.ЕдиницаИзмерения,
	|	Внебюджет.ПериодПлана,
	|	Внебюджет.РазделЛицевогоСчета,
	|	Внебюджет.КодЦели,
	|	Внебюджет.КодМероприятия,
	|	Внебюджет.ДопКлассификация,
	|	Внебюджет.ОКП,
	|	Внебюджет.ЗапретИзменения
	|ПОМЕСТИТЬ ДокументВнебюджет
	|ИЗ
	|	&ТаблицаДокументаВнебюджет КАК Внебюджет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументБюджет.ОбъектФАИП,
	|	ДокументБюджет.Подразделение,
	|	ДокументБюджет.КФО,
	#Вставка
	|	ДокументБюджет.ИФО,
	#КонецВставки
	|	ДокументБюджет.КПС,
	|	ДокументБюджет.КЭК,
	|	ДокументБюджет.Номенклатура,
	|	ДокументБюджет.ЕдиницаИзмерения,
	|	ДокументБюджет.ПериодПлана,
	|	ДокументБюджет.РазделЛицевогоСчета,
	|	ДокументБюджет.КодЦели,
	|	ДокументБюджет.КодМероприятия,
	|	ДокументБюджет.ДопКлассификация,
	|	ДокументБюджет.ОКП,
	|	ДокументБюджет.ЗапретИзменения
	|ПОМЕСТИТЬ ДанныеДокумента
	|ИЗ
	|	ДокументБюджет КАК ДокументБюджет
	|ГДЕ
	|	ДокументБюджет.ЗапретИзменения
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДокументВнебюджет.ОбъектФАИП,
	|	ДокументВнебюджет.Подразделение,
	|	ДокументВнебюджет.КФО,
	#Вставка
	|	ДокументВнебюджет.ИФО,
	#КонецВставки
	|	ДокументВнебюджет.КПС,
	|	ДокументВнебюджет.КЭК,
	|	ДокументВнебюджет.Номенклатура,
	|	ДокументВнебюджет.ЕдиницаИзмерения,
	|	ДокументВнебюджет.ПериодПлана,
	|	ДокументВнебюджет.РазделЛицевогоСчета,
	|	ДокументВнебюджет.КодЦели,
	|	ДокументВнебюджет.КодМероприятия,
	|	ДокументВнебюджет.ДопКлассификация,
	|	ДокументВнебюджет.ОКП,
	|	ДокументВнебюджет.ЗапретИзменения
	|ИЗ
	|	ДокументВнебюджет КАК ДокументВнебюджет
	|ГДЕ
	|	ДокументВнебюджет.ЗапретИзменения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПФОСрезПоследних.КлючАналитики.ОбъектФАИП КАК ОбъектФАИП,
	|	ПФОСрезПоследних.КлючАналитики.Подразделение КАК Подразделение,
	|	ПФОСрезПоследних.КлючАналитики.КФО КАК КФО,
	|	ПФОСрезПоследних.КлючАналитики.КПС КАК КПС,
	|	ПФОСрезПоследних.КлючАналитики.КЭК КАК КЭК,
	|	ПФОСрезПоследних.КлючАналитики.Номенклатура КАК Номенклатура,
	|	ПФОСрезПоследних.КлючАналитики.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ПФОСрезПоследних.КлючАналитики.ПериодПлана КАК ПериодПлана,
	|	ПФОСрезПоследних.КлючАналитики.РазделЛицевогоСчета КАК РазделЛицевогоСчета,
	|	ПФОСрезПоследних.КлючАналитики.КодЦели КАК КодЦели,
	|	ПФОСрезПоследних.КлючАналитики.КодМероприятия КАК КодМероприятия,
	|	ПФОСрезПоследних.КлючАналитики.ДопКлассификация КАК ДопКлассификация,
	|	ПФОСрезПоследних.ОКП
	|ПОМЕСТИТЬ ДанныеОснования
	|ИЗ
	|	РегистрСведений.ПланФинансированияОбязательств.СрезПоследних(
	|			,
	|			Обязательство = &Обязательство
	|				И &УсловиеРегистратор
	|				) КАК ПФОСрезПоследних
	|ГДЕ
	|	(ПФОСрезПоследних.Количество <> 0
	|			ИЛИ ПФОСрезПоследних.Сумма <> 0
	|			ИЛИ ПФОСрезПоследних.СуммаВВалюте <> 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сопоставление.ОбъектФАИП,
	|	Сопоставление.Подразделение,
	|	Сопоставление.КФО,
	|	Сопоставление.КПС,
	|	Сопоставление.КЭК,
	|	Сопоставление.Номенклатура,
	|	Сопоставление.ЕдиницаИзмерения,
	|	Сопоставление.ПериодПлана,
	|	Сопоставление.РазделЛицевогоСчета,
	|	Сопоставление.КодЦели КАК КодЦели,
	|	Сопоставление.КодМероприятия КАК КодМероприятия,
	|	Сопоставление.ДопКлассификация КАК ДопКлассификация,
	|	Сопоставление.ОКП,
	|	Сопоставление.НетПоДокументу
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДанныеОснования.ОбъектФАИП КАК ОбъектФАИП,
	|		ДанныеОснования.Подразделение КАК Подразделение,
	|		ДанныеОснования.КФО КАК КФО,
	|		ДанныеОснования.КПС КАК КПС,
	|		ДанныеОснования.КЭК КАК КЭК,
	|		ДанныеОснования.Номенклатура КАК Номенклатура,
	|		ДанныеОснования.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ДанныеОснования.ПериодПлана КАК ПериодПлана,
	|		ДанныеОснования.РазделЛицевогоСчета КАК РазделЛицевогоСчета,
	|		ДанныеОснования.КодЦели КАК КодЦели,
	|		ДанныеОснования.КодМероприятия КАК КодМероприятия,
	|		ДанныеОснования.ДопКлассификация КАК ДопКлассификация,
	|		ДанныеОснования.ОКП КАК ОКП,
	|		ВЫБОР
	|			КОГДА ДанныеДокумента.КФО ЕСТЬ NULL 
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК НетПоДокументу
	|	ИЗ
	|		ДанныеОснования КАК ДанныеОснования
	|			ЛЕВОЕ СОЕДИНЕНИЕ ДанныеДокумента КАК ДанныеДокумента
	|			ПО ДанныеОснования.ОбъектФАИП = ДанныеДокумента.ОбъектФАИП
	|				И ДанныеОснования.Подразделение  = ДанныеДокумента.Подразделение
	|				И ДанныеОснования.КФО = ДанныеДокумента.КФО
	|				И ДанныеОснования.КПС = ДанныеДокумента.КПС
	|				И ДанныеОснования.КЭК = ДанныеДокумента.КЭК
	|				И ДанныеОснования.Номенклатура = ДанныеДокумента.Номенклатура
	|				И ДанныеОснования.ЕдиницаИзмерения = ДанныеДокумента.ЕдиницаИзмерения
	|				И ДанныеОснования.ПериодПлана = ДанныеДокумента.ПериодПлана
	|				И ДанныеОснования.РазделЛицевогоСчета = ДанныеДокумента.РазделЛицевогоСчета
	|				И ДанныеОснования.КодЦели = ДанныеДокумента.КодЦели
	|				И ДанныеОснования.КодМероприятия = ДанныеДокумента.КодМероприятия
	|				И ДанныеОснования.ДопКлассификация = ДанныеДокумента.ДопКлассификация
	|				И ДанныеОснования.ОКП = ДанныеДокумента.ОКП) КАК Сопоставление
	|ГДЕ
	|	Сопоставление.НетПоДокументу";

	Запрос.УстановитьПараметр("ТаблицаДокументаВнебюджет", РасшифровкаОбязательстваВнебюджет.Выгрузить());
	Запрос.УстановитьПараметр("ТаблицаДокументаБюджет", РасшифровкаОбязательстваБюджет.Выгрузить());
	Запрос.УстановитьПараметр("Обязательство", Договор);

	Если ДополнительныеСвойства.СтруктураРеквизитовДоговора.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.ИноеОбязательство Тогда

		Если СтруктураКорректировки.ДействующийДокумент <> Ссылка Тогда

			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеРегистратор", "Регистратор = &Регистратор");
			Запрос.Текст = ТекстЗапроса;
			Запрос.УстановитьПараметр("Регистратор", СтруктураКорректировки.ДействующийДокумент);					
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				ТекстОшибки = НСтр("ru='Данные по документу не актуальны (изменилась предыдущая редакция документа!)'");
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект,,, Отказ );							
			КонецЕсли; 

		КонецЕсли; 

	Иначе 

		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеРегистратор", "Регистратор <> &Регистратор И ГОД(КлючАналитики.ПериодПлана.ДатаОкончания) >= &ДатаИзменений");
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Регистратор", Ссылка);
		Запрос.УстановитьПараметр("ДатаИзменений", Дата);

		Выборка = Запрос.Выполнить().Выбрать();

		Если Выборка.Следующий() Тогда

			ТекстОшибки = НСтр("ru='Данные по документу не актуальны, необходимо перезаполнить документ по договору!'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект,,, Отказ );					

		КонецЕсли; 

	КонецЕсли; 

КонецПроцедуры
