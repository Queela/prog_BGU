﻿
&НаСервере
&ИзменениеИКонтроль("ЗаполнитьСписываемыеМатериалыГСМНаСервере")
Процедура АБК_ЗаполнитьСписываемыеМатериалыГСМНаСервере()
	Объект.Материалы.Очистить();
    #Вставка     
	Если Объект.ВидТаксировки = Перечисления.ВидыТаксировкиДокументовУчетаГСМ.СводныйРасчетРасходаГСМПоТаксировкам Тогда 
		ТаблицаРасходаГСМ = ПолучитьТаблицуРасходаГСМ();	
	Иначе  
		ТаблицаРасходаГСМ = Объект.ФактическийРасходГСМ.Выгрузить(,"ВидГСМ,ФактическийРасходГорючего,НормативныйРасходГорючего");  
		ТаблицаРасходаГСМ.Колонки.Добавить("ТранспортноеСредство");
		Для Каждого Стр Из ТаблицаРасходаГСМ Цикл 
			Стр.ТранспортноеСредство = Объект.ТранспортноеСредство;	
		КонецЦикла;
	КонецЕсли;
	#КонецВставки
	//списание по фактическому расходу 
	#Удаление
	Для каждого ТекРасход Из Объект.ФактическийРасходГСМ Цикл 
	#КонецУдаления
	#Вставка     
	Для каждого ТекРасход Из ТаблицаРасходаГСМ Цикл 
	#КонецВставки
		СписатьВидГСМ = ТекРасход.ВидГСМ;
		СписатьКоличество = ТекРасход.ФактическийРасходГорючего;
		НормаРасхода = ТекРасход.НормативныйРасходГорючего;

		Если СписатьКоличество > 0 Тогда
			#Удаление
			НастройкиСписанияГСМПоУмолчанию = УчетГСМ.НастройкиСписанияГСМПоУмолчанию(Объект.Организация, Объект.ТранспортноеСредство, СписатьВидГСМ);
			#КонецУдаления
			#Вставка     
			НастройкиСписанияГСМПоУмолчанию = УчетГСМ.НастройкиСписанияГСМПоУмолчанию(Объект.Организация, ТекРасход.ТранспортноеСредство, СписатьВидГСМ);
			#КонецВставки
			Номенклатура = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].Номенклатура, Справочники.Номенклатура.ПустаяСсылка());
			СчетУчетаНоменклатуры = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, ПланыСчетов.ЕПСБУ.НайтиПоКоду(НастройкиСписанияГСМПоУмолчанию[0].СчетУчета), ПланыСчетов.ЕПСБУ.ПустаяСсылка());
			ЕдиницаИзмеренияГСМ = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].Номенклатура.ЕдиницаИзмерения, Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка());
			ИФО = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].ИФО, Справочники.ИсточникиФинансовогоОбеспечения.ПустаяСсылка());
			Подразделение = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].Подразделение, Справочники.Подразделения.ПустаяСсылка());
			КФО = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].КФО, Перечисления.КВД.ПустаяСсылка());
			КПС = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].КПС, Справочники.КлассификационныеПризнакиСчетов.ПустаяСсылка());

			ЦМО = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].ЦМО, Справочники.ЦМО.ПустаяСсылка());
			Если (ТипЗнч(ЦМО) = Тип("СправочникСсылка.МестаХранения"))И(ЗначениеЗаполнено(ЦМО)) Тогда
				ЦМО = УчетГСМ.ЦМОПоСотрудникуИМестуХранения(Объект.МОЛ, ЦМО);
			КонецЕсли;	

			ПодразделениеДт = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].ПодразделениеДт, Справочники.Подразделения.ПустаяСсылка());
			КПСДт = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].КПСДт, Справочники.КлассификационныеПризнакиСчетов.ПустаяСсылка());

			ДополнительнаяАналитикаСчета = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].ДополнительнаяАналитикаСчета, ПланыВидовХарактеристик.ВидыСубконто.ПустаяСсылка());
			ПричинаСписания = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].ПричинаСписания, "");

			СчетДт = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].СчетДт, ПланыСчетов.ЕПСБУ.ПустаяСсылка());
			СубконтоДт1 = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].СубконтоДт1, ПланыВидовХарактеристик.ВидыСубконто.ПустаяСсылка());
			СубконтоДт2 = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].СубконтоДт2, ПланыВидовХарактеристик.ВидыСубконто.ПустаяСсылка());
			СубконтоДт3 = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].СубконтоДт3, ПланыВидовХарактеристик.ВидыСубконто.ПустаяСсылка());

			СчетНУ = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].СчетНУ, ПланыСчетов.ЕПСБУ.ПустаяСсылка());
			СубконтоНУ1 = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].СубконтоНУ1, ПланыВидовХарактеристик.ВидыСубконто.ПустаяСсылка());
			СубконтоНУ2 = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].СубконтоНУ2, ПланыВидовХарактеристик.ВидыСубконто.ПустаяСсылка());
			СубконтоНУ3 = ?(НастройкиСписанияГСМПоУмолчанию.Количество()>0, НастройкиСписанияГСМПоУмолчанию[0].СубконтоНУ3, ПланыВидовХарактеристик.ВидыСубконто.ПустаяСсылка());

			НоваяСтрока = Объект.Материалы.Добавить();

			НоваяСтрока.ИФО = ИФО;
			НоваяСтрока.Подразделение = ?(УчетПоПодразделениямДляСчетовУчета, Подразделение, Справочники.Подразделения.ПустаяСсылка());

			НоваяСтрока.Номенклатура = Номенклатура;
			НоваяСтрока.СчетУчета = СчетУчетаНоменклатуры;
			НоваяСтрока.КФО = КФО;
			НоваяСтрока.КПС = КПС;
			НоваяСтрока.ЦМО = ЦМО;
			НоваяСтрока.ДополнительнаяАналитикаСчета = ДополнительнаяАналитикаСчета;

			НоваяСтрока.СчетДт = СчетДт;
			НоваяСтрока.СубконтоДт1 = СубконтоДт1;
			НоваяСтрока.СубконтоДт2 = СубконтоДт2;
			НоваяСтрока.СубконтоДт3 = СубконтоДт3;

			НоваяСтрока.ПодразделениеДт = ПодразделениеДт;
			НоваяСтрока.КПСДт = КПСДт;

			НоваяСтрока.СчетНУ = СчетНУ;
			НоваяСтрока.СубконтоНУ1 = СубконтоНУ1;
			НоваяСтрока.СубконтоНУ2 = СубконтоНУ2;
			НоваяСтрока.СубконтоНУ3 = СубконтоНУ3;

			НоваяСтрока.Количество = СписатьКоличество;
			НоваяСтрока.КоличествоНорма = НормаРасхода;

			НоваяСтрока.ПричинаСписания = ПричинаСписания;
			НоваяСтрока.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;	
	КонецЦикла;	

	УправлениеМатериальнымиЗапасамиКлиентСервер.УстановитьДанныеДинамическихКолонокТаблицыМатериалы(ЭтаФорма, Объект);
	ЗаполнитьДобавленныеКолонкиТаблиц();

КонецПроцедуры    

&НаСервере
Функция ПолучитьТаблицуРасходаГСМ()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаксировкаПутевогоЛистаТаксировкиПутевыхЛистов.ТаксировкаПутевогоЛиста КАК ТаксировкаПутевогоЛиста
	|ПОМЕСТИТЬ ВТ_Таксировки
	|ИЗ
	|	Документ.ТаксировкаПутевогоЛиста.ТаксировкиПутевыхЛистов КАК ТаксировкаПутевогоЛистаТаксировкиПутевыхЛистов
	|ГДЕ
	|	ТаксировкаПутевогоЛистаТаксировкиПутевыхЛистов.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаксировкаПутевогоЛистаФактическийРасходГСМ.ВидГСМ КАК ВидГСМ,
	|	СУММА(ТаксировкаПутевогоЛистаФактическийРасходГСМ.ФактическийРасходГорючего) КАК ФактическийРасходГорючего,
	|	ТаксировкаПутевогоЛистаФактическийРасходГСМ.НормативныйРасходГорючего КАК НормативныйРасходГорючего,
	|	ТаксировкаПутевогоЛистаФактическийРасходГСМ.Ссылка.ТранспортноеСредство КАК ТранспортноеСредство
	|ИЗ
	|	Документ.ТаксировкаПутевогоЛиста.ФактическийРасходГСМ КАК ТаксировкаПутевогоЛистаФактическийРасходГСМ
	|ГДЕ
	|	ТаксировкаПутевогоЛистаФактическийРасходГСМ.Ссылка В
	|			(ВЫБРАТЬ
	|				ВТ_Таксировки.ТаксировкаПутевогоЛиста
	|			ИЗ
	|				ВТ_Таксировки КАК ВТ_Таксировки)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаксировкаПутевогоЛистаФактическийРасходГСМ.ВидГСМ,
	|	ТаксировкаПутевогоЛистаФактическийРасходГСМ.НормативныйРасходГорючего,
	|	ТаксировкаПутевогоЛистаФактическийРасходГСМ.Ссылка.ТранспортноеСредство"; 
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // ПолучитьТаблицуРасходаГСМ()

