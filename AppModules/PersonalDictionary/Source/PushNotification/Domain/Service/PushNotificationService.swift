//
//  PushNotificationBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

/// Служба для работы с пуш-уведомлениями.
public protocol PushNotificationService {

    /// Поставить показ уведомления в расписание.
    /// Метод должен быть вызван в момент, когда приложение уходит с экрана (становится неактивным).
    func schedule()
}
