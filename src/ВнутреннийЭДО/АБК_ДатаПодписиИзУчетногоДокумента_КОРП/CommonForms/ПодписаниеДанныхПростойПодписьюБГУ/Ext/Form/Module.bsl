﻿&НаКлиенте
&Вместо("Подписать")
Процедура АБК_ДатаПодписанияВнутрЭДПодписатьВместо(Команда)
	Если РежимВыбораДолжности
		И Элементы.ДолжностьВыбор.СписокВыбора.Количество() > 0
		И НЕ ЗначениеЗаполнено(ДолжностьВыбор) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Необходимо выбрать должность'"), , "ДолжностьВыбор");
		Возврат;
	КонецЕсли;
	СвойстваПользователя = СвойстваПользователяИБ(Пользователь);

	ПодписаниеУспешно = НЕ ТребуетсяВводПароля ИЛИ ПарольПроверенРанее ИЛИ ПарольПроверенУспешно(СвойстваПользователя.ИдентификаторПользователяИБ);
	
	Если НЕ ПодписаниеУспешно Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан неверный пароль'"), , "Пароль");
		Возврат;
	КонецЕсли;
		
	Для Каждого ЭлементДанных Из ОписаниеДанных.НаборДанных Цикл
		СвойстваПодписи = Новый Структура;
		//Апогей-БК
		Если ЭтаФорма.ИспользоватьДатуДокумента Тогда 
				СвойстваПодписи.Вставить("ДатаПодписи", АБК_ДополнительныеФункцииЭДО.ПолучитьДатуУчетногоДокумента(ЭлементДанных.УчетныйДокумент));
			Иначе
				СвойстваПодписи.Вставить("ДатаПодписи", ЭтаФорма.ДатаПодписи);
		КонецЕсли;
		//Апогей-БК
		СвойстваПодписи.Вставить("ВладелецПодписи", ПолноеИмя);
		Если РежимВыбораДолжности Тогда
			СвойстваПодписи.Вставить("Организация", ДолжностьВыбор.Организация);
			СвойстваПодписи.Вставить("Должность", ДолжностьВыбор.Должность);
		Иначе
			СвойстваПодписи.Вставить("Организация",
				ОписаниеДанных.СведенияДляПростойПодписи.ОрганизацииИДолжности[ЭлементДанных.ЭлектронныйДокумент].Организация);
			СвойстваПодписи.Вставить("Должность",
				ОписаниеДанных.СведенияДляПростойПодписи.ОрганизацииИДолжности[ЭлементДанных.ЭлектронныйДокумент].Должность);
		КонецЕсли;
		СвойстваПодписи.Вставить("УстановившийПодпись", Пользователь);
		ЭлементДанных.Вставить("СвойстваПодписи", СвойстваПодписи);
	КонецЦикла;
	
	Если ТребуетсяВводПароля Тогда
		ИмяПараметра = "ВнутреннийЭДОБГУ.ПарольПростойЭлектроннойПодписиПроверен";
		ПараметрыПриложения.Вставить(ИмяПараметра, ЗапомнитьПароль);
	КонецЕсли;
	
	Закрыть(Истина);

	
КонецПроцедуры   


&НаСервере
&После("ПриСозданииНаСервере")
Процедура АБК_ДатаПодписанияВнутрЭДПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаПодписи =  ТекущаяДата();
	
	ДобавляемыеРеквизиты	= Новый Массив;
	
	// Опишем ревизиты формы
	Реквизит_ДатаПодписи = Новый РеквизитФормы("ДатаПодписи",	Новый ОписаниеТипов("Дата", Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	Реквизит_ИспользоватьДатуДокумента = Новый РеквизитФормы("ИспользоватьДатуДокумента", Новый ОписаниеТипов("Булево"));
	// Заполним массив после описания реквизитов формы
	ДобавляемыеРеквизиты.Добавить(Реквизит_ДатаПодписи);
	ДобавляемыеРеквизиты.Добавить(Реквизит_ИспользоватьДатуДокумента);
	
	// Добавим новые реквизиты в форму
	ЭтаФорма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	ЭтаФорма.ДатаПодписи = ДатаПодписи;
	ЭтаФорма.ИспользоватьДатуДокумента = ИСТИНА;
	//Проверка включать реквизит или нет 	
	ГруппаФормы = ЭтаФорма.Элементы.Найти("ГруппаПоля");
		Если ГруппаФормы <> Неопределено Тогда
			ЭлементФормыДата = ЭтаФорма.Элементы.Добавить("ДатаПодписи", Тип("ПолеФормы"), ГруппаФормы);        
			ЭлементФормыДата.Вид = ВидПоляФормы.ПолеВвода;
			ЭлементФормыДата.ПутьКДанным = "ДатаПодписи";
			ЭлементФормыДата.Заголовок = "Дата подписания";
			ЭлементФормыДата.Высота = 1;
			ЭлементФормыИспользоватьДату = ЭтаФорма.Элементы.Добавить("ИспользоватьДатуДокумента", Тип("ПолеФормы"), ГруппаФормы);        
			ЭлементФормыИспользоватьДату.Вид = ВидПоляФормы.ПолеПереключателя;
			ЭлементФормыИспользоватьДату.ПутьКДанным = "ИспользоватьДатуДокумента";
			ЭлементФормыИспользоватьДату.Заголовок = "Дата подписи из документа";
			ЭтаФорма.Элементы.ДатаПодписи.Доступность = ЛОЖЬ;
			ЭлементФормыИспользоватьДату.УстановитьДействие("ПриИзменении", "АБК_ДатаПодписанияВнутрЭДИспользоватьДатуДокументаПриИзменении");
		КонецЕсли;
	//Конец проверки
	
	
КонецПроцедуры

&НаКлиенте
Процедура АБК_ДатаПодписанияВнутрЭДИспользоватьДатуДокументаПриИзменении(Элемент)
	
	Если ЭтаФорма.ИспользоватьДатуДокумента Тогда
		ЭтаФорма.Элементы.ДатаПодписи.Доступность = ЛОЖЬ;
	Иначе
		ЭтаФорма.Элементы.ДатаПодписи.Доступность = ИСТИНА;
	КонецЕсли;
		
КонецПроцедуры


