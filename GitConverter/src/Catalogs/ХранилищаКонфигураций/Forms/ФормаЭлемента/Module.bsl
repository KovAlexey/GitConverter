///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2017-2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by-sa/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////
// @strict-types

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		ПриЧтенииСозданииНаСервере();
	
	КонецЕсли;
	
	СисИнфо = Новый СистемнаяИнформация;
	Элементы.ВерсияПлатформы.ПодсказкаВвода = СисИнфо.ВерсияПриложения;
	Элементы.ВерсияПлатформы.СписокВыбора.Очистить();
	
	Для Каждого ДоступнаяВерсия Из ОбщегоНазначенияПовтИсп.СписокДоступныхВерсийПлатформы() Цикл
	
		Элементы.ВерсияПлатформы.СписокВыбора.Добавить(ДоступнаяВерсия);
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	ОбновитьСостояниеНаСервере();
	
	ИмяФайлаЛога = КонвертацияХранилища.ИмяФайлаЛогаКонвертацииХранилища(ТекущийОбъект.КаталогВыгрузкиВерсий);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если АвтообновлениеСостоянияЗадания Тогда
	
		ОбновитьСостояниеНаКлиенте();
	
	КонецЕсли; 
	
	Элементы.ФормаОбновлятьСостояниеАвтоматически.Пометка = АвтообновлениеСостоянияЗадания;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Расписание", Расписание);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Использование", РегламентноеЗаданиеИспользуется);
	Если ТекущийОбъект.Наименование = ТекущийАдрес Тогда
		ТекущийОбъект.Наименование = ТекущийОбъект.Адрес;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьСостояниеНаКлиенте();
	Если ЗначениеЗаполнено(Объект.Ссылка) И НЕ Объект.КонвертироватьВФорматEDT Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Конвертация в формат 1С:Предприятия является устаревшей. Рекомендуется выполнить конвертацию в формат 1C:EDT.'"));
	КонецЕсли;
	ТекущийАдрес = Объект.Адрес;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(Объект.ВерсияПлатформы) ИЛИ РегламентноеЗаданиеИспользуется Тогда
		ПутьКВерсиям = Константы.ПутьКВерсиямПлатформыНаСервере.Получить();
		Если НЕ ЗначениеЗаполнено(ПутьКВерсиям) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнена константа ""Путь к версиям Платформы на сервере"".'");
			Сообщение.ПутьКДанным = "Объект.ВерсияПлатформы";
			Сообщение.КлючДанных = Объект.Ссылка;
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РегламентноеЗаданиеИспользуетсяПриИзменении(Элемент)
	
	УстановитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеСтрокойНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ДиалогРасписания.Показать(Новый ОписаниеОповещения("РасписаниеСтрокойНажатиеЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЛогаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ИмяФайлаЛога) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = Новый ТекстовыйДокумент();
	
	ИмяФайла = "";
	ПрочитатьТекстовыйФайлНаСервере(ИмяФайлаЛога, Текст, ИмяФайла);
	
	Текст.Показать(ИмяФайла, ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныйКаталогGitПриИзменении(Элемент)
	
	ПроверитьНаличиеРепозитория();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресРепозиторияGitПриИзменении(Элемент)
	
	УстановитьДоступность(ЭтаФорма);
	ЗадатьВопросПроверкиДоступаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательСервераGitПриИзменении(Элемент)
	
	ЗадатьВопросПроверкиДоступаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольСервераGitПриИзменении(Элемент)
	
	ЗадатьВопросПроверкиДоступаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипХранилищаПриИзменении(Элемент)
	
	УстановитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяCLIПриИзменении(Элемент)
	УстановитьВидимостьВерсииEDT();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСостояние(Команда)
	
	ОбновитьСостояниеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьКонвертацию(Команда)
	
	ЗапуститьКонвертациюНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКоммиты(Команда)
	
	ВыполнитьКоммитыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлятьСостояниеАвтоматически(Команда)
	
	АвтообновлениеСостоянияЗадания = НЕ АвтообновлениеСостоянияЗадания;
	Элементы.ФормаОбновлятьСостояниеАвтоматически.Пометка = АвтообновлениеСостоянияЗадания;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРепозиторийGit(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ЛокальныйКаталогGit) Тогда
	
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан локальный каталог репозитория Git'"));
		Возврат;
	
	КонецЕсли; 
	
	Если Модифицированность ИЛИ Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Если НЕ Записать() Тогда
		
			Возврат;
		
		КонецЕсли; 
	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.АдресРепозиторияGit) Тогда

		Результат = ПроверитьДоступКРепозиториюGitНаСервере();

		Если Не Результат.Успешно Тогда
			ПоказатьПредупреждение( , НСтр("ru = 'Ошибка доступа к репозиторию на сервере:'") + Символы.ПС
				+ Результат.ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		ОбновитьИменаВеток(Результат.Ветки);
		
		Если Результат.Ветки.Количество() > 0 Тогда

			Оповещение = Новый ОписаниеОповещения("СоздатьРепозиторийGitНаСервереОтвет", ЭтотОбъект);
			ТекстВопроса = НСтр("ru = 'Указанный репозиторий на сервере не пустой, содержит ветки.
										  |Всё равно, создать новый локальный репозиторий?'");
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Создать новый, установить адрес!'"));
			Если Результат.Ветки.Найти(Объект.ИмяВетки) <> Неопределено Тогда
				Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Клонировать эту ветку с сервера'"));
			Иначе
				Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Клонировать с сервера и создать ветку'"));
			КонецЕсли;
			Кнопки.Добавить(КодВозвратаДиалога.Отмена);
			ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Отмена, НСтр("ru = 'Внимание!'"));
			Возврат;
		КонецЕсли;
	
	КонецЕсли; 
	
	ТекстЛога = Новый ТекстовыйДокумент();
	СоздатьРепозиторийGitНаСервере(ТекстЛога);
	ТекстЛога.Показать(НСтр("ru = 'Лог операции'"), "log.txt");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВерсииИзОтчетаПоХранилищу(Команда)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Фильтр = "Отчет по версиям хранилища(*.mxl)|*.mxl";
	Диалог.ПроверятьСуществованиеФайла = Истина;
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьВерсииИзОтчетаПоХранилищуВыбор", ЭтотОбъект);
	
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьАдресРепозиторияGit(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.АдресРепозиторияGit) Тогда
	
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан адрес репозитория на сервере Git'"));
		Возврат;
	
	КонецЕсли; 
	
	Если Модифицированность Тогда
	
		Если НЕ Записать() Тогда
		
			Возврат;
		
		КонецЕсли; 
	
	КонецЕсли;
	
	Результат = ПроверитьДоступКРепозиториюGitНаСервере();
	
	Если НЕ Результат.Успешно Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Ошибка доступа к репозиторию на сервере:'") + Символы.ПС + Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	ОбновитьИменаВеток(Результат.Ветки);
	
	Если Результат.Ветки.Найти(Объект.ИмяВетки) <> Неопределено Тогда
		
		Оповещение = Новый ОписаниеОповещения("УстановитьАдресРепозиторияGitОтвет", ЭтотОбъект);
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Ветка %1 существует на сервере. При отправке изменений могут возникнуть конфилкты, которые необходимо будет разрешить вручную.
									  |Установить адрес сервера?'"), Объект.ИмяВетки);
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Понимаю, установить адрес сервера!'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Выбрать другую ветку'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, ,КодВозвратаДиалога.Отмена, НСтр("ru = 'Внимание!'"));
		Возврат;
	КонецЕсли;
	
	ТекстЛога = Новый ТекстовыйДокумент();
	УстановитьАдресРепозиторияGitНаСервере(ТекстЛога, Ложь);
	ТекстЛога.Показать(НСтр("ru = 'Лог операции'"), "log.txt");
	
КонецПроцедуры

&НаКлиенте
Процедура КонвертироватьВФорматEDT(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Конвертировать в формат 1C:EDT можно только существующий репозиторий.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Хранилище", Объект.Ссылка);
	ОткрытьФорму("Обработка.КонвертацияВФорматEDT.Форма", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДоступнуюВерсиюEDT(Команда)

	Версия = Объект.ВерсияПлатформы;
	Если НЕ ЗначениеЗаполнено(Версия) Тогда
		СисИнфо = Новый СистемнаяИнформация();
		Версия = СисИнфо.ВерсияПриложения;
	КонецЕсли;
	Квалификаторы = СтрРазделить(Версия, ".");
	Если Квалификаторы.Количество() = 4 Тогда
		Квалификаторы.Удалить(Квалификаторы.ВГраница());
		Версия = СтрСоединить(Квалификаторы, ".");
		РезультатОперации = ПолучитьДоступныеВерсииEDTНаСервере();
		
		Если РезультатОперации.КодОшибки = "ВключитьИспользованиеВерсийEDT" Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ВключитьИспользованиеВерсийEDT",
				ЭтотОбъект);
			ПоказатьВопрос(
				ОписаниеОповещения,
				НСтр("ru = 'Установлено несколько версий EDT, для корретной работоты утилиты ring необходимо
					|указать номер версии. Включить возможность определения номера версии?'"),
				РежимДиалогаВопрос.ДаНет);
			Возврат;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			Возврат;
		КонецЕсли;
		
		ВерсияНайдена = Ложь;
		Для Каждого ВерсияEDT Из РезультатОперации.ВерсииEDT Цикл
			Если Версия = ВерсияEDT Тогда
				ВерсияНайдена = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ВерсияНайдена Тогда
			Текст = НСтр("ru = 'Версия ''%Версия%'' доступна для конвертации в формат 1C:EDT.'");
		ИначеЕсли РезультатОперации.ВерсииEDT.Количество() = 0 Тогда
			Текст = НСтр("ru = 'Не обнаружено доступных версий в 1C:EDT!
						 |Возможно 1C:EDT версии 1.8 и выше не установлена на сервере или недоступна для запуска.'");
		Иначе
			Текст = НСтр("ru = 'Версия ''%Версия%'' не доступна для конвертации в формат 1C:EDT.
						 |Укажите версию платформы из доступных: %ВерсииEDT%.'");
			Текст = СтрЗаменить(Текст, "%ВерсииEDT%", СтрСоединить(РезультатОперации.ВерсииEDT, ", "));
		КонецЕсли;
		Текст = СтрЗаменить(Текст, "%Версия%", Версия);
	Иначе
		Текст = НСтр("ru = 'Версия платформы должна быть в формате Х.Х.Х.Х'");
	КонецЕсли;
	
	ПоказатьПредупреждение(, Текст);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДоступКРепозиториюGit(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.АдресРепозиторияGit) Тогда
	
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан адрес репозитория на сервере Git'"));
		Возврат;
	
	КонецЕсли; 
	
	Результат = ПроверитьДоступКРепозиториюGitНаСервере();
	
	Если НЕ Результат.Успешно Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Ошибка доступа к репозиторию на сервере:'") + Символы.ПС + Результат.ТекстОшибки);
		Возврат;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Проверка доступа к репозиторию на сервере выполнена успешно.
		|На сервере веток:'") + " " + Результат.Ветки.Количество());
	КонецЕсли;
	
	ОбновитьИменаВеток(Результат.Ветки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСписокВеток(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.АдресРепозиторияGit) Тогда
	
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан адрес репозитория на сервере Git'"));
		Возврат;
	
	КонецЕсли;
	
	Результат = ПроверитьДоступКРепозиториюGitНаСервере();
	
	Если НЕ Результат.Успешно Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Ошибка запроса списка веток:'") + Символы.ПС + Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	ОбновитьИменаВеток(Результат.Ветки);
	
	Если Результат.Ветки.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ВыборИмениВеткиОтвет", ЭтотОбъект);
		Элементы.ИмяВетки.СписокВыбора.ПоказатьВыборЭлемента(Оповещение, НСтр("ru = 'Выберите ветку серверного репозитория'"));
	Иначе
		ПоказатьПредупреждение( , НСтр("ru = 'На сервере 0 веток.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьВерсииEDT()
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВерсийEDT") Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ИспользуетсяCLI Тогда
		ПоказыватьВыборВерсииEDTCLI = Истина; 
	Иначе
		ПоказыватьВыборВерсииEDTCLI = Ложь;
	КонецЕсли;
	
	Элементы.ВерсияEDTCLI.Видимость = ПоказыватьВыборВерсииEDTCLI;
	Элементы.ВерсияEDT.Видимость = НЕ ПоказыватьВыборВерсииEDTCLI;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСостояниеНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		СостояниеЗадания = "";
		Возврат;
	
	КонецЕсли;
	
	Отбор = Новый Структура();
	Отбор.Вставить("Ключ", Строка(Объект.Ссылка.УникальныйИдентификатор()));
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	Отбор.Вставить("ИмяМетода", "КонвертацияХранилища.ВыполнитьКонвертацию");
	
	МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
	Если МассивФоновыхЗаданий.Количество() > 0 Тогда
		Задание = МассивФоновыхЗаданий[0];
		СостояниеЗадания = НСтр("ru = 'Выполняется конвертация с %Дата%'");
		СостояниеЗадания = СтрЗаменить(СостояниеЗадания, "%Дата%", Задание.Начало);
		
	ИначеЕсли ЗначениеЗаполнено(Объект.РегламентноеЗадание) Тогда
		СостояниеЗадания = "";
		РегЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(
			Новый УникальныйИдентификатор(Объект.РегламентноеЗадание));
		Если РегЗадание <> Неопределено Тогда
			СвойстваПоследнегоФоновогоЗадания = РегламентныеЗаданияСлужебный.ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(РегЗадание);
			Если СвойстваПоследнегоФоновогоЗадания <> Неопределено
					И СвойстваПоследнегоФоновогоЗадания.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
				СостояниеЗадания = СтрШаблон(НСтр("ru = 'Задание конвертации завершено аварийно в %1 по причине: %2'"), СвойстваПоследнегоФоновогоЗадания.Конец, СвойстваПоследнегоФоновогоЗадания.ОписаниеИнформацииОбОшибке);
			КонецЕсли;
		КонецЕсли;
	Иначе
		СостояниеЗадания = "";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВерсииХранилища.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.ВерсииХранилища КАК ВерсииХранилища
	|ГДЕ
	|	ВерсииХранилища.Владелец = &Хранилище
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВерсииХранилища.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.ВерсииХранилища КАК ВерсииХранилища
	|ГДЕ
	|	ВерсииХранилища.Владелец = &Хранилище
	|	И ВерсииХранилища.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВерсии.ВерсияПомещена)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВерсииХранилища.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.ВерсииХранилища КАК ВерсииХранилища
	|ГДЕ
	|	ВерсииХранилища.Владелец = &Хранилище
	|	И ВерсииХранилища.Состояние В (ЗНАЧЕНИЕ(Перечисление.СостоянияВерсии.МетаданныеЗагружены),
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияВерсии.НачалоКоммита))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВерсииХранилища.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.ВерсииХранилища КАК ВерсииХранилища
	|ГДЕ
	|	ВерсииХранилища.Владелец = &Хранилище
	|	И
	|	НЕ ВерсииХранилища.Состояние В (ЗНАЧЕНИЕ(Перечисление.СостоянияВерсии.ПустаяСсылка),
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияВерсии.НачалоКоммита), ЗНАЧЕНИЕ(Перечисление.СостоянияВерсии.ВерсияПомещена))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВерсииХранилища.Ссылка) КАК Количество,
	|	МАКСИМУМ(СостоянияВерсииСрезПоследних.Период) КАК Окончание,
	|	МИНИМУМ(СостоянияВерсииСрезПоследних.Период) КАК Начало
	|ПОМЕСТИТЬ ОбщаяСкорость
	|ИЗ
	|	Справочник.ВерсииХранилища КАК ВерсииХранилища
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВерсии.СрезПоследних КАК СостоянияВерсииСрезПоследних
	|		ПО ВерсииХранилища.Ссылка = СостоянияВерсииСрезПоследних.ВерсияХранилища
	|ГДЕ
	|	ВерсииХранилища.Владелец = &Хранилище
	|	И ВерсииХранилища.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВерсии.ВерсияПомещена)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА РАЗНОСТЬДАТ(ОбщаяСкорость.Начало, ОбщаяСкорость.Окончание, ЧАС) = 0
	|			ТОГДА 0
	|		ИНАЧЕ ОбщаяСкорость.Количество / РАЗНОСТЬДАТ(ОбщаяСкорость.Начало, ОбщаяСкорость.Окончание, ЧАС)
	|	КОНЕЦ КАК Скорость
	|ИЗ
	|	ОбщаяСкорость КАК ОбщаяСкорость
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВерсииХранилища.Ссылка) КАК Количество,
	|	МАКСИМУМ(СостоянияВерсииСрезПоследних.Период) КАК Окончание,
	|	МИНИМУМ(СостоянияВерсииСрезПоследних.Период) КАК Начало
	|ПОМЕСТИТЬ ТекущаяСкорость
	|ИЗ
	|	Справочник.ВерсииХранилища КАК ВерсииХранилища
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВерсии.СрезПоследних КАК СостоянияВерсииСрезПоследних
	|		ПО ВерсииХранилища.Ссылка = СостоянияВерсииСрезПоследних.ВерсияХранилища
	|ГДЕ
	|	ВерсииХранилища.Владелец = &Хранилище
	|	И ВерсииХранилища.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВерсии.ВерсияПомещена)
	|	И СостоянияВерсииСрезПоследних.Период >= &ПредыдущаяДата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА РАЗНОСТЬДАТ(ТекущаяСкорость.Начало, ТекущаяСкорость.Окончание, ЧАС) = 0
	|			ТОГДА 0
	|		ИНАЧЕ ТекущаяСкорость.Количество / РАЗНОСТЬДАТ(ТекущаяСкорость.Начало, ТекущаяСкорость.Окончание, ЧАС)
	|	КОНЕЦ КАК Скорость
	|ИЗ
	|	ТекущаяСкорость КАК ТекущаяСкорость";
	
	Запрос.УстановитьПараметр("ПредыдущаяДата", ТекущаяДатаСеанса() - 86400);
	Запрос.УстановитьПараметр("Хранилище", Объект.Ссылка);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаДетальныеЗаписи = РезультатыЗапроса[0].Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	ВсегоВерсий = ВыборкаДетальныеЗаписи.Количество;
	
	ВыборкаДетальныеЗаписи = РезультатыЗапроса[1].Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	КоличествоКоммитов = ВыборкаДетальныеЗаписи.Количество;
	
	ВыборкаДетальныеЗаписи = РезультатыЗапроса[2].Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	КоличествоВерсийОбработано = ВыборкаДетальныеЗаписи.Количество;
	
	ВыборкаДетальныеЗаписи = РезультатыЗапроса[3].Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	КоличествоПодготавливаемыхВерсий = ВыборкаДетальныеЗаписи.Количество;
	
	ВыборкаДетальныеЗаписи = РезультатыЗапроса[5].Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	СредняяСкорость = ВыборкаДетальныеЗаписи.Скорость;
	
	ВыборкаДетальныеЗаписи = РезультатыЗапроса[7].Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	СредняяСкоростьЗаСутки = ВыборкаДетальныеЗаписи.Скорость;
	

КонецПроцедуры

&НаСервере
Процедура ЗапуститьКонвертациюНаСервере()
	
	Отбор = Новый Структура();
	Ключ = Строка(Объект.Ссылка.УникальныйИдентификатор());
	Отбор.Вставить("Ключ", Ключ);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	Отбор.Вставить("ИмяМетода", "КонвертацияХранилища.ВыполнитьКонвертацию");

	МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);

	Если МассивФоновыхЗаданий.Количество() > 0 Тогда
		Задание = МассивФоновыхЗаданий[0];
		СостояниеЗадания = НСтр("ru = 'Выполняется конвертация с %Дата%'");
		СостояниеЗадания = СтрЗаменить(СостояниеЗадания, "%Дата%", Задание.Начало);

	Иначе
		СостояниеЗадания = "";
		
		ПараметрыЗадания = Новый Массив;
		ПараметрыЗадания.Добавить(Объект.Ссылка);
		
		НаименованиеЗадания = НСтр("ru = 'Конвертация хранилища'") + ": ";
	
		НаименованиеЗадания = Лев(НаименованиеЗадания + СокрЛП(Объект.Адрес), 120);
		
		ФоновыеЗадания.Выполнить("КонвертацияХранилища.ВыполнитьКонвертацию", ПараметрыЗадания, Ключ, НаименованиеЗадания);
		
	КонецЕсли;
	
	ОбновитьСостояниеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКоммитыНаСервере()
	
	КонвертацияХранилища.ЗапуститьКоммитыВФоне(Объект.Ссылка);
	
	ОбновитьСостояниеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеНаКлиенте()

	ОтключитьОбработчикОжидания("ОбновитьСостояниеНаКлиенте");
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьСостояниеНаСервере();
	
	Если АвтообновлениеСостоянияЗадания Тогда
	
		ПодключитьОбработчикОжидания("ОбновитьСостояниеНаКлиенте", 20, Истина);
	
	КонецЕсли; 

КонецПроцедуры 

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗаданияСервер.Задание(Объект.РегламентноеЗадание);
	Если Задание <> Неопределено Тогда
		Расписание = Задание.Расписание;
		РегламентноеЗаданиеИспользуется = Задание.Использование;
		РасписаниеСтрокой = Строка(Расписание);
	Иначе
		Расписание = Новый РасписаниеРегламентногоЗадания;
		РасписаниеСтрокой = РасписаниеСтрокой + Строка(Расписание);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	ПроверитьНаличиеРепозитория();
	
	ТекущийАдрес = Объект.Адрес;
	
	СисИнфо = Новый СистемнаяИнформация;
	Элементы.ВерсияПлатформы.ПодсказкаВвода = СисИнфо.ВерсияПриложения;
	
	УстановитьДоступность(ЭтаФорма);
	УстановитьВидимостьВерсииEDT();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступность(Форма)
	
	Форма.Элементы.РасписаниеСтрокой.Доступность = Форма.РегламентноеЗаданиеИспользуется;
	Форма.Элементы.КонвертироватьВФорматEDT.Видимость = НЕ Форма.Объект.КонвертироватьВФорматEDT;
	Форма.Элементы.ФормаКонвертироватьВФорматEDT.Видимость = НЕ Форма.Объект.КонвертироватьВФорматEDT;
	Форма.Элементы.ДобавлятьМеткиСВерсиейКонфигурации.Видимость = Форма.Объект.КонвертироватьВФорматEDT;
	
	Форма.Элементы.СоздатьРепозиторийGit.Доступность = НЕ Форма.РепозиторийСоздан;
	Форма.Элементы.ФормаСоздатьРепозиторийGit.Доступность = НЕ Форма.РепозиторийСоздан;
	
	ЕстьАдрес = ЗначениеЗаполнено(Форма.Объект.АдресРепозиторияGit);
	
	ЭтоHTTPАдрес = ЭтоHTTPАдрес(Форма.Объект.АдресРепозиторияGit);
	
	Форма.Элементы.ПользовательСервераGit.АвтоОтметкаНезаполненного = ЭтоHTTPАдрес;
	Форма.Элементы.ПарольСервераGit.АвтоОтметкаНезаполненного = ЭтоHTTPАдрес;
	Форма.Элементы.ЗагрузитьСписокВеток.Доступность = ЕстьАдрес;
	Форма.Элементы.УстановитьАдресРепозиторияGit.Доступность = ЕстьАдрес И Форма.РепозиторийСоздан;
	Форма.Элементы.ПроверитьДоступКРепозиториюGit.Доступность = ЕстьАдрес;
	
	
	ЭтоРасширение = Форма.Объект.ТипХранилища =
		ПредопределенноеЗначение("Перечисление.ТипыХранилищаКонфигураций.Расширение");
	Форма.Элементы.БазовыйПроект.Видимость = ЭтоРасширение;
	Форма.Элементы.ИмяРасширения.Видимость = ЭтоРасширение;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДоступныеВерсииEDTНаСервере()
	
	РезультатОперации = Новый Структура;
	РезультатОперации.Вставить("КодОшибки", "");
	РезультатОперации.Вставить("ВерсииEDT", Новый Массив());
	
	ИспользоватьНесколькоВерсийEDT = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВерсийEDT");
	Если НЕ Объект.ИспользуетсяCLI
	И Не ЗначениеЗаполнено(Объект.ВерсияEDT) 
	И ИспользоватьНесколькоВерсийEDT Тогда
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Поле Версия EDT не заполнено.'");
		Сообщение.Поле = "Объект.ВерсияEDT";
		Сообщение.КлючДанных = Объект.Ссылка;
		Сообщение.Сообщить();
		
		РезультатОперации.КодОшибки = "ВерсияEDTНеЗаполнена";
		
		Возврат РезультатОперации;
	КонецЕсли;
	
	Если Объект.ИспользуетсяCLI 
	И Не ИспользоватьНесколькоВерсийEDT 
	И КонвертацияХранилища.НеобходимоЗаполнитьВерсиюEDT() Тогда
		РезультатОперации.КодОшибки = "ВключитьИспользованиеВерсийEDT";
		Возврат РезультатОперации;
	КонецЕсли;
	
	Если Не Объект.ИспользуетсяCLI Тогда
		РезультатОперации.ВерсииEDT = КонвертацияХранилища.ПолучитьСписокВерсийПлатформыEDT(Объект.ВерсияEDT);
	Иначе
		//РезультатОперации.ВерсииEDT = конверт
	КонецЕсли;
	
	Возврат РезультатОперации;
	
КонецФункции


// Параметры:
// 	КодВозварта - КодВозвратаДиалога
// 	ДополнительныеПараметры - Неопределено
&НаКлиенте
Процедура ВключитьИспользованиеВерсийEDT(КодВозварта, ДополнительныеПараметры) Экспорт 
	
	Если КодВозварта = КодВозвратаДиалога.Да Тогда
		УстановитьИспользоватьНесколькоВерсийEDT();
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьИспользоватьНесколькоВерсийEDT()
	
	Константы.ИспользоватьНесколькоВерсийEDT.Установить(Истина);
	
КонецПроцедуры


// Параметры:
// 	Расписание1 - РасписаниеРегламентногоЗадания, Неопределено -
// 	ДополнительныеПараметры - Неопределено
&НаКлиенте
Процедура РасписаниеСтрокойНажатиеЗавершение(Расписание1, ДополнительныеПараметры) Экспорт
	
	Если Расписание1 <> Неопределено Тогда
		
		Модифицированность = Истина;
		Расписание         = Расписание1;
		РасписаниеСтрокой  = Строка(Расписание);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПроверитьНаличиеРепозитория()

	РепозиторийСоздан = Ложь;
	Если ЗначениеЗаполнено(Объект.ЛокальныйКаталогGit) Тогда
		
		НайденныеФайлы = НайтиФайлы(Объект.ЛокальныйКаталогGit, "*");
		Для Каждого Файл Из НайденныеФайлы Цикл

			Если НРег(Файл.Имя) = ".git" Тогда

				РепозиторийСоздан = Истина;
				Прервать;

			КонецЕсли;

		КонецЦикла;

	КонецЕсли; 
	
	УстановитьДоступность(ЭтотОбъект);
	
КонецПроцедуры


// Параметры:
// 	ВыбранныеФайлы - Неопределено, Массив из Строка -
// 	ДополнительныеПараметры - Неопределено
&НаКлиенте
Процедура ЗагрузитьВерсииИзОтчетаПоХранилищуВыбор(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныеФайлы = Неопределено ИЛИ ВыбранныеФайлы.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли; 
	
	ПолноеИмяФайла = ВыбранныеФайлы[0];
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьВерсииИзОтчетаПоХранилищуПослеПомещения", ЭтотОбъект);
	
	НачатьПомещениеФайла(Оповещение, , ПолноеИмяФайла, Ложь, УникальныйИдентификатор);
	
	
КонецПроцедуры


// Параметры:
// 	Результат - Булево
// 	АдресФайла - Строка
// 	ВыбранноеИмяФайла - Строка
// 	ДополнительныеПараметры - Неопределено
&НаКлиенте
Процедура ЗагрузитьВерсииИзОтчетаПоХранилищуПослеПомещения(Результат, АдресФайла, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт 
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли; 
	
	ЗагрузитьВерсииИзОтчетаПоХранилищуНаСервере(АдресФайла);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВерсииИзОтчетаПоХранилищуНаСервере(АдресФайла)
	
	Файл = ПолучитьИзВременногоХранилища(АдресФайла); // ДвоичныеДанные - 
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
	Файл.Записать(ИмяВременногоФайла);
	
	Справочники.ВерсииХранилища.ЗагрузитьВерсииИзОтчета(Объект.Ссылка, ИмяВременногоФайла);
	
	УдалитьФайлы(ИмяВременногоФайла);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьРепозиторийGitНаСервере(ЛогОперации)
	
	КонвертацияХранилища.СоздатьРепозиторийGit(Объект.Ссылка, ЛогОперации);
	
	ПроверитьНаличиеРепозитория();
	
КонецПроцедуры

&НаСервере
Процедура КлонироватьРепозиторийGitСоздатьВеткуНаСервере(ЛогОперации)
	
	КонвертацияХранилища.СоздатьРепозиторийGit(Объект.Ссылка, ЛогОперации, Истина, Истина);
	
	ПроверитьНаличиеРепозитория();
	
КонецПроцедуры

&НаСервере
Процедура КлонироватьРепозиторийGitНаСервере(ЛогОперации)
	
	КонвертацияХранилища.СоздатьРепозиторийGit(Объект.Ссылка, ЛогОперации, Истина, Ложь);
	
	ПроверитьНаличиеРепозитория();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьАдресРепозиторияGitНаСервере(ЛогОперации, ВеткаСуществует)
	
	КонвертацияХранилища.УстановитьАдресРепозиторияGit(Объект.Ссылка, ЛогОперации, ВеткаСуществует);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПрочитатьТекстовыйФайлНаСервере(ПутьКФайлу, Текст, ИмяФайла, КодировкаСистемы = Ложь)
	
	ОбщегоНазначения.ПрочитатьТекстовыйФайл(ПутьКФайлу, Текст, ИмяФайла, КодировкаСистемы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРепозиторийGitНаСервереОтвет(Ответ, ДополнительныеПараметры) Экспорт
	
	ТекстЛога = Новый ТекстовыйДокумент();
	ПоказыватьЛог = Ложь;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПоказыватьЛог = Истина;
		СоздатьРепозиторийGitНаСервере(ТекстЛога);
	ИначеЕсли  Ответ = КодВозвратаДиалога.ОК Тогда
		ПоказыватьЛог = Истина;
		КлонироватьРепозиторийGitНаСервере(ТекстЛога);
	ИначеЕсли  Ответ = КодВозвратаДиалога.Нет Тогда
		ПоказыватьЛог = Истина;
		КлонироватьРепозиторийGitСоздатьВеткуНаСервере(ТекстЛога);
	КонецЕсли;
	
	Если ПоказыватьЛог Тогда
		ТекстЛога.Показать(НСтр("ru = 'Лог операции'"), "log.txt");
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьАдресРепозиторияGitОтвет(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ТекстЛога = Новый ТекстовыйДокумент();
		УстановитьАдресРепозиторияGitНаСервере(ТекстЛога, Истина);
		ТекстЛога.Показать(НСтр("ru = 'Лог операции'"), "log.txt");
	ИначеЕсли  Ответ = КодВозвратаДиалога.Нет Тогда
		Объект.ИмяВетки = "";
		Модифицированность = Истина;
		ЭтотОбъект.ТекущийЭлемент = Элементы.ИмяВетки;
	КонецЕсли;
		
КонецПроцедуры


&НаКлиенте
Процедура ЗадатьВопросПроверкиДоступаПриИзменении()
	
	Если ЗначениеЗаполнено(Объект.АдресРепозиторияGit) 
		И НЕ РепозиторийСоздан
		И (НЕ ЭтоHTTPАдрес(Объект.АдресРепозиторияGit) 
		ИЛИ ЗначениеЗаполнено(Объект.ПользовательСервераGit)
		И ЗначениеЗаполнено(Объект.ПарольСервераGit)) Тогда
		
		Оповещение = Новый ОписаниеОповещения("ЗадатьВопросПроверкиДоступаПриИзмененииОтвет", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Проверить доступ к репозиторию на сервере и загрузить список веток?'");
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Проверить и загрузить список веток'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, ,КодВозвратаДиалога.Да, НСтр("ru = 'Внимание!'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросПроверкиДоступаПриИзмененииОтвет(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.ИмяВетки = "";
		Модифицированность = Истина;
		
		Результат = ПроверитьДоступКРепозиториюGitНаСервере();
		Если Не Результат.Успешно Тогда
			ПоказатьПредупреждение( , НСтр("ru = 'Ошибка запроса списка веток:'") + Символы.ПС + Результат.ТекстОшибки);
			Возврат;
		КонецЕсли;

		ОбновитьИменаВеток(Результат.Ветки);

		ЭтотОбъект.ТекущийЭлемент = Элементы.ИмяВетки;
		Если Результат.Ветки.Количество() > 0 Тогда
			Оповещение = Новый ОписаниеОповещения("ВыборИмениВеткиОтвет", ЭтотОбъект);
			Элементы.ИмяВетки.СписокВыбора.ПоказатьВыборЭлемента(Оповещение, НСтр("ru = 'Выберите ветку серверного репозитория'"));
		Иначе
			ПоказатьПредупреждение( , НСтр("ru = 'На сервере 0 веток.'"));
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыборИмениВеткиОтвет(Ответ, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Ответ) = Тип("ЭлементСпискаЗначений") Тогда
		Объект.ИмяВетки = Ответ.Значение;
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
// 	Адрес - Строка - адрес для проверки
// Возвращаемое значение:
// 	Булево - Истина, если это адресс HTTP или HTTPS
&НаКлиентеНаСервереБезКонтекста
функция ЭтоHTTPАдрес(Адрес)
	Возврат СтрНачинаетсяС(Адрес, "http://") ИЛИ СтрНачинаетсяС(Адрес, "https://");
КонецФункции

&НаКлиенте
Процедура ОбновитьИменаВеток(Ветки)
	
	Элементы.ИмяВетки.СписокВыбора.Очистить();
	Если Ветки.Найти("master") = Неопределено Тогда
		Элементы.ИмяВетки.СписокВыбора.Добавить("master", "master (?)");
	КонецЕсли;
	
	Для Каждого Ветка Из Ветки Цикл
		Элементы.ИмяВетки.СписокВыбора.Добавить(Ветка);
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Функция ПроверитьДоступКРепозиториюGitНаСервере()
	
	ЭтоHTTPАдрес = ЭтоHTTPАдрес(Объект.АдресРепозиторияGit);
	
	АдресРепозиторияGit =  Объект.АдресРепозиторияGit;
	Если ЭтоHTTPАдрес Тогда
		ПозицияРазделителя = СтрНайти(АдресРепозиторияGit, "://");
		Если ПозицияРазделителя > 0 и ЗначениеЗаполнено(Объект.ПользовательСервераGit) Тогда
			АдресРепозиторияGit = Лев(АдресРепозиторияGit, ПозицияРазделителя + 2)
				+ Объект.ПользовательСервераGit + ":"
				+ Объект.ПарольСервераGit + "@"
				+ Прав(АдресРепозиторияGit, СтрДлина(АдресРепозиторияGit)
				- ПозицияРазделителя - 2);
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонвертацияХранилища.ПолучитьИнформациюРепозиторияGitНаСервере(АдресРепозиторияGit);
КонецФункции


#КонецОбласти
