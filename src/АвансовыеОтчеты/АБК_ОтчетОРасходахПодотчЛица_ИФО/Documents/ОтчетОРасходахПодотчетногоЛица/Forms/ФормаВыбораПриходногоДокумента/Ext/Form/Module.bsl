﻿
&НаСервере
Процедура АБК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	Если Элементы.Найти("СписокИФО") = Неопределено Тогда
		
		Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса,
		"ВЫБРАТЬ
		|	ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор КАК Регистратор",
		"ВЫБРАТЬ
		|	ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор КАК Регистратор,
		|	ЖурналПроводокЕПСБУДвиженияССубконто.ИФО КАК ИФО");    
		
		Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса,
		"СГРУППИРОВАТЬ ПО
		|	ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор",
		"СГРУППИРОВАТЬ ПО
		|	ЖурналПроводокЕПСБУДвиженияССубконто.Регистратор,
		|	ЖурналПроводокЕПСБУДвиженияССубконто.ИФО");   
		
		НовЭл = Элементы.Вставить("СписокИФО",Тип("ПолеФормы"),Элементы.Список,Элементы.Валюта);
		НовЭл.ПутьКДанным = "Список.ИФО";
		НовЭл.Вид = ВидПоляФормы.ПолеВвода;   
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоИФО") Тогда
			Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "ИФО = &ИФО", "ИСТИНА");	
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
&ИзменениеИКонтроль("ОповеститьВладельцаОВыборе")
Процедура АБК_ОповеститьВладельцаОВыборе(ТекущиеДанные)

	Результат = Новый Структура;
	Результат.Вставить("ПриходныйДокумент", ТекущиеДанные.Регистратор);
	Результат.Вставить("СуммаФакт", ТекущиеДанные.Сумма);
	Результат.Вставить("СуммаПринято", ТекущиеДанные.Сумма);
	Результат.Вставить("ДатаДокумента", ТекущиеДанные.ДатаПервичногоДокумента);
	Результат.Вставить("НомерДокумента", ТекущиеДанные.НомерПервичногоДокумента);
	Результат.Вставить("НаименованиеДокумента", ТекущиеДанные.ВидПервичногоДокумента);
	Результат.Вставить("Контрагент", ТекущиеДанные.Грузоотправитель);
	#Вставка
	Результат.Вставить("ИФО", ТекущиеДанные.ИФО);
	#КонецВставки

	ОповеститьОВыборе(Результат);

КонецПроцедуры
