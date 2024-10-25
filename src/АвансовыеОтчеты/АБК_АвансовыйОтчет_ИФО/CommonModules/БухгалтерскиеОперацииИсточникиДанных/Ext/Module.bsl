﻿
&ИзменениеИКонтроль("АвансовыйОтчет_ТаблицаКорректировкиДенежныхОбязательств")
Функция АБК_АвансовыйОтчет_ТаблицаКорректировкиДенежныхОбязательств(ВариантВызова, ИсточникиДанных, ТиповаяОперация, Параметры)

	Если ВариантВызова = "ПолучитьПараметры" Тогда

		Возврат Новый Массив;

	КонецЕсли;

	ОписаниеТипаСуммы = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(18, 2, ДопустимыйЗнак.Любой));

	ПоляФункции = Новый Массив;

	ДобавитьПолеРезультатаФункции(ПоляФункции, "Обязательство", 	Новый ОписаниеТипов("СправочникСсылка.Договоры"));
	ДобавитьПолеРезультатаФункции(ПоляФункции, "РазделЛицСчета", 	Новый ОписаниеТипов("СправочникСсылка.РазделыЛицевыхСчетов"));
	ДобавитьПолеРезультатаФункции(ПоляФункции, "КФО", 				Новый ОписаниеТипов("ПеречислениеСсылка.КВД"));                 
	#Вставка
	ДобавитьПолеРезультатаФункции(ПоляФункции, "ИФО", 				Новый ОписаниеТипов("СправочникСсылка.ИсточникиФинансовогоОбеспечения"));                 
	#КонецВставки
	ДобавитьПолеРезультатаФункции(ПоляФункции, "КПС", 				Новый ОписаниеТипов("СправочникСсылка.КлассификационныеПризнакиСчетов")); 
	ДобавитьПолеРезультатаФункции(ПоляФункции, "КЭК", 				Новый ОписаниеТипов("СправочникСсылка.КОСГУ"));
	ДобавитьПолеРезультатаФункции(ПоляФункции, "ДопКлассификация",	Новый ОписаниеТипов("СправочникСсылка.ДополнительнаяБюджетнаяКлассификация"));
	ДобавитьПолеРезультатаФункции(ПоляФункции, "КодМероприятия",	Новый ОписаниеТипов("СправочникСсылка.Мероприятия"));
	ДобавитьПолеРезультатаФункции(ПоляФункции, "КодЦели",			Новый ОписаниеТипов("СправочникСсылка.ВидыЦелевыхСредств"));
	ДобавитьПолеРезультатаФункции(ПоляФункции, "Валюта",			Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	ДобавитьПолеРезультатаФункции(ПоляФункции, "Сумма", 			ОписаниеТипаСуммы);
	ДобавитьПолеРезультатаФункции(ПоляФункции, "СуммаВВалюте", 		ОписаниеТипаСуммы);

	Если ВариантВызова = "ПолучитьПоля" Тогда
		Возврат ПоляФункции;
	КонецЕсли;

	Если ВариантВызова <> "Выполнить" Тогда
		Возврат Неопределено;
	КонецЕсли;

	ТаблицаРезультат = Новый ТаблицаЗначений;
	ДобавитьКолонкиРезультатаПоОписанию(ТаблицаРезультат, ПоляФункции);

	ПрефиксДокумента = БухгалтерскиеОперацииСервер.ПрефиксКолонкиИсточникаДанных("Документ");

	РеквизитыДокумента = РеквизитыДокумента(ИсточникиДанных);

	ЗаявлениеНаВыдачуАванса = РеквизитыДокумента.ЗаявлениеНаВыдачуАванса;

	Если ЗначениеЗаполнено(ЗаявлениеНаВыдачуАванса) Тогда
		РеквизитыЗаявления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ЗаявлениеНаВыдачуАванса, "ОснованиеПринятияОбязательства, РазделЛицевогоСчета");
		Обязательство = РеквизитыЗаявления.ОснованиеПринятияОбязательства;
		РазделЛицСчета = РеквизитыЗаявления.РазделЛицевогоСчета;
	Иначе
		Обязательство = РеквизитыДокумента.ОснованиеПринятияОбязательства;
		РазделЛицСчета = РеквизитыДокумента.РазделЛицевогоСчета;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Обязательство) Тогда
		Возврат ТаблицаРезультат;
	КонецЕсли;

	Реквизиты = Новый Структура;
	Реквизиты.Вставить("Ссылка", РеквизитыДокумента.Ссылка);
	Реквизиты.Вставить("ЗаявлениеНаВыдачуАванса", ЗаявлениеНаВыдачуАванса);
	Реквизиты.Вставить("Обязательство", Обязательство);
	Реквизиты.Вставить("РазделЛицСчета", РазделЛицСчета);

	ТаблицаРезультат = РасчетыСПодотчетнымиЛицами.ТаблицаДенежныхОбязательствПоТЧАвансовогоОтчета(Реквизиты);

	Если ТаблицаРезультат.Количество() = 0 Тогда

		КонтекстПроведения = БухгалтерскиеОперацииСервер.ПолучитьКонтекстЗаполненияОперации();
		ДополнительныеСвойства = КонтекстПроведения.ДополнительныеСвойства;

		РасходыПоАвансовомуОтчету = ?(ДополнительныеСвойства.Свойство("РасходыПоАвансовомуОтчету"),
		ДополнительныеСвойства.РасходыПоАвансовомуОтчету,
		РасчетыСПодотчетнымиЛицами.ПустаяТаблицаРасходовПоАвансовомуОтчету());

		ТаблицаРезультат = РасчетыСПодотчетнымиЛицами.ТаблицаКорректировкиДенежныхОбязательствПоАвансовомуОтчету(
		Реквизиты, РасходыПоАвансовомуОтчету);

	КонецЕсли;

	КонтекстПроведения = БухгалтерскиеОперацииСервер.ПолучитьКонтекстЗаполненияОперации();
	КонтекстПроведения.ДополнительныеСвойства.Вставить("ТаблицаКорректировкиДенежныхОбязательств", ТаблицаРезультат.Скопировать());
	БухгалтерскиеОперацииСервер.СохранитьКонтекстЗаполненияОперации(КонтекстПроведения);

	Возврат ТаблицаРезультат;

КонецФункции
