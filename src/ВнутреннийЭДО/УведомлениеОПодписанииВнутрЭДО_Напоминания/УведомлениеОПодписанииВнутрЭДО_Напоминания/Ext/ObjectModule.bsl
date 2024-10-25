﻿#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// Возвращает сведения о внешней обработке.
//
// Возвращаемое значение:
//   Структура - Подробнее см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке().
//
Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.3.1");
	ПараметрыРегистрации.Наименование = ЭтотОбъект.Метаданные().Синоним;
	ПараметрыРегистрации.Информация = НСтр("ru = '" + ЭтотОбъект.Метаданные().Комментарий + "'");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Версия = "100.36.00";     
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = "Уведомление о подписании внутр. ЭД (АБК) Напоминания пользователя";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.Идентификатор = "АБК_УведомлениеОПодписанииВнутрЭД_НапоминанияПользователя";
	
	Возврат ПараметрыРегистрации;
КонецФункции

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#КонецОбласти

Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	Если ИдентификаторКоманды = "АБК_УведомлениеОПодписанииВнутрЭД_НапоминанияПользователя" тогда
		УстановитьПривилегированныйРежим(Истина);     
		
		СвойствоОтправленныеУведомления = НайтиСоздатьДополнительноеСведение();
		
		ЗапросДляУдаления = Новый Запрос;
		ЗапросДляУдаления.Текст = 
		"ВЫБРАТЬ
		|	НапоминанияПользователя.Пользователь КАК Пользователь,
		|	НапоминанияПользователя.ВремяСобытия КАК ВремяСобытия,
		|	НапоминанияПользователя.Источник КАК Источник
		|ИЗ
		|	РегистрСведений.НапоминанияПользователя КАК НапоминанияПользователя
		|ГДЕ
		|	НапоминанияПользователя.Описание ПОДОБНО &Описание
		|	И (НЕ НапоминанияПользователя.Идентификатор ПОДОБНО &Идентификатор
		|			ИЛИ НАЧАЛОПЕРИОДА(НапоминанияПользователя.ВремяСобытия, ДЕНЬ) < &ТекущаяДата)";
		ЗапросДляУдаления.УстановитьПараметр("Описание","%ЭтоУведомлениеЭДО%");
		ЗапросДляУдаления.УстановитьПараметр("Идентификатор","%ЭтоНапоминаниеНеОткладывали%");
		ЗапросДляУдаления.УстановитьПараметр("ТекущаяДата",НачалоДня(ТекущаяДата()));
		
		Результат = ЗапросДляУдаления.Выполнить().Выгрузить();
		Для Каждого Стр из Результат Цикл
			СтруктураУдаления = Новый Структура("Пользователь,ВремяСобытия,Источник",Стр.Пользователь,Стр.ВремяСобытия,Стр.Источник);
			НапоминанияПользователяСлужебный.ОтключитьНапоминание(СтруктураУдаления);	
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Состояние", Перечисления.СостоянияДокументовВнутреннегоЭДО.ТребуетсяПодписание);
		Запрос.УстановитьПараметр("Свойство", СвойствоОтправленныеУведомления);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоставМаршрутаЭлектронногоДокумента.ЭлектронныйДокумент КАК ЭлектронныйДокумент,
		|	СоставМаршрутаЭлектронногоДокумента.Подписант КАК Подписант,
		|	ЕСТЬNULL(ДополнительныеСведения.Значение, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПоследнегоНапоминания
		|ИЗ
		|	РегистрСведений.СоставМаршрутаЭлектронногоДокумента КАК СоставМаршрутаЭлектронногоДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
		|		ПО СоставМаршрутаЭлектронногоДокумента.ЭлектронныйДокумент = ДополнительныеСведения.Объект
		|			И (ДополнительныеСведения.Свойство = &Свойство)
		|ГДЕ
		|	СоставМаршрутаЭлектронногоДокумента.Состояние = &Состояние
		|	И НЕ СоставМаршрутаЭлектронногоДокумента.ЭлектронныйДокумент.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	СоставМаршрутаЭлектронногоДокумента.ЭлектронныйДокумент,
		|	СоставМаршрутаЭлектронногоДокумента.Подписант,
		|	ЕСТЬNULL(ДополнительныеСведения.Значение, ДАТАВРЕМЯ(1, 1, 1))
		|ИТОГИ ПО
		|	Подписант";
		Результат = Запрос.Выполнить();
		
		ДанныеДляНапоминаний = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		ТекущаяДата = ТекущаяДата(); 
		
		Пока ДанныеДляНапоминаний.Следующий() Цикл
			ВыборкаДокументов = ДанныеДляНапоминаний.Выбрать();
			Пока ВыборкаДокументов.Следующий() Цикл     
				Если НЕ ЗначениеЗаполнено(ВыборкаДокументов.ДатаПоследнегоНапоминания)
					ИЛИ НачалоДня(ВыборкаДокументов.ДатаПоследнегоНапоминания) < НачалоДня(ТекущаяДата) Тогда 
					
					Текст = "Вам необходимо подписать ";
					Текст = Текст + ВыборкаДокументов.ЭлектронныйДокумент; 
					Текст = Текст + " ЭтоУведомлениеЭДО"; 
					ПараметрыНапоминания = Новый Структура("Описание,Пользователь,ВремяСобытия,Идентификатор,ИнтервалДоСобытия,Источник,ПредставлениеИсточника",Текст,ДанныеДляНапоминаний.Подписант,ТекущаяДата,"ЭтоНапоминаниеНеОткладывали",,);
					
					Напоминание = СоздатьНапоминание(ПараметрыНапоминания);
					НапоминанияПользователяСлужебный.ПодключитьНапоминание(Напоминание); 
					
					ЗаписатьДатуНапоминания(ВыборкаДокументов.ЭлектронныйДокумент, СвойствоОтправленныеУведомления, НачалоДня(ТекущаяДата));					
				КонецЕсли;
			КонецЦикла;      
		КонецЦикла;  
	КонецЕсли;
	
КонецПроцедуры 

Функция СоздатьНапоминание(ПараметрыНапоминания)
	
	Напоминание = НапоминанияПользователяКлиентСервер.ОписаниеНапоминания(ПараметрыНапоминания, Истина);
	
	Если Не ЗначениеЗаполнено(Напоминание.Пользователь) Тогда
		Напоминание.Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Напоминание.СпособУстановкиВремениНапоминания) Тогда
		Если ЗначениеЗаполнено(Напоминание.Источник) И Не ПустаяСтрока(Напоминание.ИмяРеквизитаИсточника) Тогда
			Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета;
		ИначеЕсли Напоминание.Расписание <> Неопределено Тогда
			Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.Периодически;
		ИначеЕсли Не ЗначениеЗаполнено(Напоминание.ВремяСобытия) Тогда
			Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноТекущегоВремени;
		Иначе
			Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя;
		КонецЕсли;
	КонецЕсли;
	
	Если Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета Тогда
		Напоминание.ВремяСобытия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Напоминание.Источник, Напоминание.ИмяРеквизитаИсточника);
		Напоминание.СрокНапоминания = Напоминание.ВремяСобытия - ?(ЗначениеЗаполнено(Напоминание.ВремяСобытия), Напоминание.ИнтервалВремениНапоминания, 0);
	ИначеЕсли Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноТекущегоВремени Тогда
		Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя;
		Напоминание.ВремяСобытия = ТекущаяДатаСеанса() + Напоминание.ИнтервалВремениНапоминания;
	ИначеЕсли Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя Тогда
		Напоминание.СрокНапоминания = Напоминание.ВремяСобытия - Напоминание.ИнтервалВремениНапоминания;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Напоминание.СрокНапоминания) Тогда
		Напоминание.СрокНапоминания = Напоминание.ВремяСобытия;
	КонецЕсли;
	
	Если Напоминание.ПовторятьЕжегодно Тогда
		Если ЗначениеЗаполнено(Напоминание.ВремяСобытия) Тогда
			Напоминание.Расписание = НапоминанияПользователяКлиентСервер.ЕжегодноеРасписание(Напоминание.ВремяСобытия);
		КонецЕсли;
	КонецЕсли;
	
	Если Напоминание.Расписание <> Неопределено Тогда
		Напоминание.ВремяСобытия = НапоминанияПользователяСлужебный.ПолучитьБлижайшуюДатуСобытияПоРасписанию(Напоминание.Расписание);
		Если Напоминание.ВремяСобытия = Неопределено Тогда
			Напоминание.ВремяСобытия = '00010101';
		КонецЕсли;
		Напоминание.СрокНапоминания = Напоминание.ВремяСобытия - Напоминание.ИнтервалВремениНапоминания;
	КонецЕсли;
	
	Напоминание.Расписание = Новый ХранилищеЗначения(Напоминание.Расписание, Новый СжатиеДанных(9));
	
	Возврат Напоминание;
	
КонецФункции

Функция НайтиСоздатьДополнительноеСведение()
	
	ИдентификаторДляФормул = "АБК_ДатаПоследнегоНапоминания";
	
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
	ДопСведение.Наименование = "Дата последнего напоминания (АБК)";
	ДопСведение.ИдентификаторДляФормул = ИдентификаторДляФормул;
	ДопСведение.Виден = Ложь;
	ДопСведение.Комментарий = "Обозначает дату последнего напоминания";
	ДопСведение.ТипЗначения = Новый ОписаниеТипов("Дата");
	ДопСведение.ЭтоДополнительноеСведение = Истина;
	ДопСведение.Записать();
	
	Возврат ДопСведение.Ссылка;
	
КонецФункции

Процедура ЗаписатьДатуНапоминания(Объект, Свойство, ДатаПоследнегоНапоминания)
	ЗаписьОтправленных = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
	ЗаписьОтправленных.Объект 	= Объект;
	ЗаписьОтправленных.Свойство = Свойство;
	ЗаписьОтправленных.Значение = ДатаПоследнегоНапоминания;
	ЗаписьОтправленных.Записать(Истина);
КонецПроцедуры
