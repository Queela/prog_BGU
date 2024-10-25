﻿
#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОткрытьНастройкуОтображенияДанныхИзТабличныхЧастей(ПараметрКоманды, ПараметрыВыполнения) Экспорт 
	
	ДинамическийСписок = СтрРазделить(ПараметрыВыполнения.ОписаниеКоманды.ИмяВФорме, "_")[1];
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяФормы", 					ПараметрыВыполнения.Форма.ИмяФормы);
	ДополнительныеПараметры.Вставить("Форма", 						ПараметрыВыполнения.Форма);
	ДополнительныеПараметры.Вставить("Пользователь", 				ИмяПользователя());
	ДополнительныеПараметры.Вставить("ДинамическийСписок", 			ДинамическийСписок);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияНастроек", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ДинамическийСписок", 			ДинамическийСписок);
	ПараметрыОткрытияФормы.Вставить("МассивПсевдонимов", 			ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.МассивПсевдонимов);
	ПараметрыОткрытияФормы.Вставить("СериализованныеНастройки", 	АБК_РасширениеФормСписковВызовСервера.ПрочитатьНастройкиИзФормы(ДополнительныеПараметры.ИмяФормы, ДополнительныеПараметры.Пользователь, ДинамическийСписок));
	ПараметрыОткрытияФормы.Вставить("ИдентификаторыМетаданных", 	ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.ИдентификаторыМетаданных);
	ПараметрыОткрытияФормы.Вставить("ЖурналДокументов", 			Булево(СтрНайти(ПараметрыВыполнения.Форма.ИмяФормы, "ЖурналДокументов")) ИЛИ ПараметрыВыполнения.Форма.ИмяФормы = "ОбщаяФорма.ЖурналПлатежноРасчетныеДокументы");
	
	ОткрытьФорму("Обработка.АБК_НастройкаФормСписков.Форма",
				ПараметрыОткрытияФормы,
				ПараметрыВыполнения.Форма,
				ПараметрыВыполнения.Форма.УникальныйИдентификатор,
				,
				,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

&НаКлиенте
Процедура ПослеЗакрытияНастроек(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат = Истина Тогда
		Результат = Неопределено;	
	КонецЕсли;
	
	АБК_РасширениеФормСписковВызовСервера.ЗаписатьНастройкиФормы(ДополнительныеПараметры.ИмяФормы, ДополнительныеПараметры.Пользователь, ДополнительныеПараметры.ДинамическийСписок, Результат);
	
	//ПоказатьОповещениеПользователя(НСтр("ru = 'Настройки записаны'"),, НСтр("ru = 'необходимо перезайти в форму списка!'"));
	
	ДополнительныеПараметры.Форма.Закрыть();
	
	ОткрытьФорму(ДополнительныеПараметры.ИмяФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
