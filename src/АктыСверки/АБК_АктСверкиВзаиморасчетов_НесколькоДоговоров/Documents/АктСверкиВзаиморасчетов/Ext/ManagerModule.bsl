﻿

&ИзменениеИКонтроль("ПолучитьДоговорыСКонтрагентом")
Функция АБК_АктСверкиВзаиморасчетов_НесколькоДоговоров_ПолучитьДоговорыСКонтрагентом(ШапкаДокумента)

	ИспользоватьОтборПоДоговору = ЗначениеЗаполнено(ШапкаДокумента["Договор"]);

	ЗапросПоиск = Новый Запрос();
	ЗапросПоиск.УстановитьПараметр("Контрагент",					ШапкаДокумента["Контрагент"]);
	ЗапросПоиск.УстановитьПараметр("Договор",						ШапкаДокумента["Договор"]);
	ЗапросПоиск.УстановитьПараметр("ИспользоватьОтборПоДоговору",	ИспользоватьОтборПоДоговору);
	ЗапросПоиск.Текст = "
	|///////////////////////////////////////////////////////////////////////////////
	|// [0]. Все договоры с указанным контрагентом
	|//
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Ссылка	КАК Ссылка
	|ИЗ
	|	Справочник.Договоры
	|ГДЕ
	|	ВЫБОР
	|		КОГДА &ИспользоватьОтборПоДоговору ТОГДА
	|			// Отбор по договору
	|			Ссылка В ИЕРАРХИИ(&Договор)
	|		ИНАЧЕ
	|			// Отбор по контрагенту
	|			Контрагент В(&Контрагент)
	|	КОНЕЦ
	|;";

	ВсеДоговоры = ЗапросПоиск.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	#Вставка
	Если ШапкаДокумента["МассивДоговоров"].Количество()>0 Тогда   
		ВсеДоговоры = ШапкаДокумента["МассивДоговоров"];
	Иначе
		ВсеДоговоры = ЗапросПоиск.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	#КонецВставки

	ПараметрыОтбора = Документы.АктСверкиВзаиморасчетов.ПолучитьПараметрыОтбораДлительныхДоговоров(
	ШапкаДокумента,
	"АктСверкиВзаиморасчетов",
	ПолучитьДатуОкончанияОбороты(ШапкаДокумента));

	ДлительныеДоговоры = ПолучитьДлительныеДоговорыСКонтрагентом(ПараметрыОтбора);

	Договоры = Новый Структура();
	Договоры.Вставить("ВсеДоговоры",		ВсеДоговоры);
	Договоры.Вставить("ДлительныеДоговоры",	ДлительныеДоговоры);

	Возврат Договоры;

КонецФункции


&ИзменениеИКонтроль("ПолучитьПараметрыЗаполнения")
Функция АБК_АктСверкиВзаиморасчетов_НесколькоДоговоров_ПолучитьПараметрыЗаполнения(ПараметрыПроцедуры)

	ШапкаДокумента			= ПараметрыПроцедуры["ШапкаДокумента"];
	СписокОтмеченныхСчетов	= ПараметрыПроцедуры["СписокОтмеченныхСчетов"];

	СчетаСтандартнойСверки = ПолучитьСчетаСтандартнойСверки(ШапкаДокумента, СписокОтмеченныхСчетов);

	ДоговорыСКонтрагентом = ПолучитьДоговорыСКонтрагентом(ШапкаДокумента);

	Параметры = Новый Структура();

	ТипыДокументовСНесколькимиПервичнымиДокументами = Новый Массив();
	ТипыДокументовСНесколькимиПервичнымиДокументами.Добавить(Тип("ДокументСсылка.ОперацияБух"));
	ТипыДокументовСНесколькимиПервичнымиДокументами.Добавить(Тип("ДокументСсылка.НачислениеДоходов"));
	ТипыДокументовСНесколькимиПервичнымиДокументами.Добавить(Тип("ДокументСсылка.ЭквайринговаяОперация"));

	// Для оборотов
	ИсключаемыеТипыРегистратора = Новый Массив();
	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.ЗакрытиеГодаТехнологическое"));
	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.ПереносОстатковПоКПС"));
	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.ПереносОстатков64нРасчеты"));
	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.ВводНачальныхОстатков"));

	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.НачислениеДоходовБудущихПериодов"));
	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.КорректировкаДоходовБудущихПериодов"));

	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуПравПользованияОС"));
	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.ПрекращениеПравПользованияОС"));

	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.НачислениеДоходовБудущихПериодовОбразование"));
	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.КорректировкаДолгосрочныхДоговоровОбразование"));
	ИсключаемыеТипыРегистратора.Добавить(Тип("ДокументСсылка.КорректировкаДоходовБудущихПериодовОбразование"));

	ИспользоватьОтборПоОрганизации	= НЕ ШапкаДокумента["ПоВсемОрганизациям"];
	ИспользоватьОтборПоПодразделению = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоПодразделениям")
	И (ЗначениеЗаполнено(ШапкаДокумента["Подразделение"]));
	ИспользоватьОтборПоДоговору		= ЗначениеЗаполнено(ШапкаДокумента["Договор"]);
	#Вставка
	ИспользоватьОтборПоДоговору		= (ЗначениеЗаполнено(ШапкаДокумента["Договор"]) ИЛИ ШапкаДокумента["МассивДоговоров"].Количество()>0);
	#КонецВставки
	ИспользоватьОтборПоИФО			= ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоИФО") И НЕ ШапкаДокумента["БезУчетаИФО"];
	ИспользоватьОтборПоКФО			= ЗначениеЗаполнено(ШапкаДокумента["КФО"]);
	ВалютаРУ						= Константы.ВалютаРегламентированногоУчета.Получить();
	ИспользоватьОтборПоВалюте		= ПолучитьФункциональнуюОпцию("ИспользоватьВалютныйУчет")
	И ЗначениеЗаполнено(ШапкаДокумента["ВалютаДокумента"])
	И НЕ ШапкаДокумента["ВалютаДокумента"] = ВалютаРУ;
	ВыбиратьВалютныеСуммы			= ПолучитьФункциональнуюОпцию("ИспользоватьВалютныйУчет")
	И ЗначениеЗаполнено(ШапкаДокумента["ВалютаДокумента"])
	И НЕ ШапкаДокумента["ВалютаДокумента"] = ВалютаРУ;

	// Стандартная (прежняя) сверка
	Параметры.Вставить("ДатаНачалаОбороты",									ПолучитьДатуНачалаОбороты(ШапкаДокумента));
	Параметры.Вставить("ДатаОкончанияОбороты",								ПолучитьДатуОкончанияОбороты(ШапкаДокумента));
	Параметры.Вставить("ДатаНачалаОстатки",									ПолучитьДатуНачалаОстатки(ШапкаДокумента));
	Параметры.Вставить("ДатаОкончанияОстатки",								ПолучитьДатуОкончанияОстатки(ШапкаДокумента));

	Параметры.Вставить("Контрагент",										ШапкаДокумента["Контрагент"]);
	Параметры.Вставить("Организация",										ШапкаДокумента["Организация"]);
	Параметры.Вставить("Подразделение",										ШапкаДокумента["Подразделение"]);
	Параметры.Вставить("ИФО",												ШапкаДокумента["ИФО"]);
	Параметры.Вставить("КФО",												ШапкаДокумента["КФО"]);
	Параметры.Вставить("Валюта",											ШапкаДокумента["ВалютаДокумента"]);
	Параметры.Вставить("ДетализироватьОстаткиПоДоговорам",					ШапкаДокумента["ДетализироватьПоДоговорам"]);

	Параметры.Вставить("ИспользоватьОтборПоОрганизации",					ИспользоватьОтборПоОрганизации);
	Параметры.Вставить("ИспользоватьОтборПоПодразделению",					ИспользоватьОтборПоПодразделению);
	Параметры.Вставить("ИспользоватьОтборПоДоговору",						ИспользоватьОтборПоДоговору);
	Параметры.Вставить("ИспользоватьОтборПоИФО",							ИспользоватьОтборПоИФО);
	Параметры.Вставить("ИспользоватьОтборПоКФО",							ИспользоватьОтборПоКФО);
	Параметры.Вставить("ИспользоватьОтборПоВалюте",							ИспользоватьОтборПоВалюте);
	Параметры.Вставить("ВыбиратьВалютныеСуммы",								ВыбиратьВалютныеСуммы);
	Параметры.Вставить("ВалютаРУ",											ВалютаРУ);
	Параметры.Вставить("ВидСубконтоДоговоры",								ПланыВидовХарактеристик.ВидыСубконто.Договоры);
	Параметры.Вставить("ТипыДокументовСНесколькимиПервичнымиДокументами",	ТипыДокументовСНесколькимиПервичнымиДокументами);
	Параметры.Вставить("ТипыПлатежныхДокументов",							ПолучитьТипыПлатежныхДокументов());
	Параметры.Вставить("ИсключаемыеТипыРегистратора",						ИсключаемыеТипыРегистратора);

	Параметры.Вставить("СчетаСтандартнойСверки",							СчетаСтандартнойСверки);
	Параметры.Вставить("ДоговорыСКонтрагентом",								ДоговорыСКонтрагентом);

	// Для сверки по длительным договорам
	НастройкиДляСверкиПоДлительнымДоговорам = ПолучитьНастройкиДляСверкиПоДлительнымДоговорам(
	ШапкаДокумента,
	СписокОтмеченныхСчетов,
	СчетаСтандартнойСверки,
	ДоговорыСКонтрагентом);

	Параметры.Вставить("НастройкиДляСверкиПоДлительнымДоговорам",			НастройкиДляСверкиПоДлительнымДоговорам);

	Параметры.Вставить("ДатаПерехода64н",									УчетНДС.ПолучитьДатуНачалаПрименения64н(ШапкаДокумента.Организация));

	Параметры.Вставить("СворачиватьОбороты",								ШапкаДокумента.СворачиватьОбороты);

	Возврат Параметры;

КонецФункции

