//
//  Created by Netology.
//

import XCTest

class NetologyUITests: XCTestCase {
    
    func testLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        let username = "username"
        
        let loginTextField = app.textFields["login"]
        loginTextField.tap()
        loginTextField.typeText(username)
        
        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        
        let loginButton = app.buttons["login"]
        XCTAssertTrue(loginButton.isEnabled)
        loginButton.tap()
        
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", username)
        let text = app.staticTexts.containing(predicate)
        XCTAssertNotNil(text)
        
        let fullScreenshot = XCUIScreen.main.screenshot()
        let screenshot = XCTAttachment(screenshot: fullScreenshot)
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
    
    func testLoginButtonDisabledAfterErasingUsername() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Пользователь вводит логин
        let loginTextField = app.textFields["login"]
        loginTextField.tap()
        loginTextField.typeText("username")
        
        // Пользователь вводит пароль
        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        
        // Пользователь стирает введённый логин
        loginTextField.tap()
        if let currentValue = loginTextField.value as? String {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentValue.count)
            loginTextField.typeText(deleteString)
        }
        
        // Проверка, что кнопка Login не активна
        let loginButton = app.buttons["login"]
        XCTAssertFalse(loginButton.isEnabled)
    }
    
    func testLoginWithDifferentUsername() throws {
        let app = XCUIApplication()
        app.launch()

        // Пользователь вводит первый логин
        let loginTextField = app.textFields["login"]
        loginTextField.tap()
        loginTextField.typeText("firstUsername")

        // Пользователь вводит пароль
        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("123456")

        // Пользователь нажимает кнопку Login
        let loginButton = app.buttons["login"]
        loginButton.tap()

        // Пользователь нажимает кнопку Назад
        let backButton = app.buttons["Login"]
        backButton.tap()

        // Пользователь вводит второй логин
        loginTextField.tap()
        if let currentValue = loginTextField.value as? String {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentValue.count)
            loginTextField.typeText(deleteString)
        }
        loginTextField.typeText("secondUsername")

        // Пользователь нажимает кнопку Login снова
        loginButton.tap()

        // Используем NSPredicate для поиска текста, содержащего второй логин
        let secondUsernamePredicate = NSPredicate(format: "label CONTAINS[c] %@", "secondUsername")
        let secondUsernameElement = app.staticTexts.containing(secondUsernamePredicate).element(boundBy: 1)
        XCTAssertTrue(secondUsernameElement.exists)
    }

    
}
