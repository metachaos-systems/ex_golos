# ExGolos

Scroll down for English version of this readme.

ExGolos -- это Elixir библиотека для взаимодействия с нодами GOLOS с использованием JSONRPC протокола.

## Установка :ex_golos

  1. Добавьте `:ex_golos` в список зависимостей в `mix.exs`:

    ```elixir
    def deps do
      [{:ex_golos, "~> 0.1.0"}]
    end
    ```

  2. Добавьте ':golos' в список applications в `mix.exs`:
    ```elixir
    def application do
      [applications: [:logger, :golos]]
    end
    ```

## Конфигурация

Сначала пропишите вебсокет урл для ноды Голоса в конфиг. Если ожидаете высокие нагрузки используйте собственную ноду, в ином случае подойдет публичная нода Голоса `wss://ws.golos.io`. Для удобства можно использовать ENV переменные, например, GOLOS_URL.

```elixir
config :golos,
  url: "GOLOS_URL"
```

## Пример использования

Самая важная функция в модуле: `Golos.call`. Вызов функции заблокирует процесс до возврата success tuple с результатом или ошибкой, полученными в результате обработки JSONRPC вызов нодой. Id для JSONRPC вызовов задавать не надо, модуль их назначает и обрабатывает автоматически.

`Golos.call("database_api", "get_dynamic_global_properties", [])`

## Дорожная карта

ExGolos находится в активной разработке.

* Внедрить создание и управление подписками
* Исследовать использование GenStage
* Добавить функции для всех типов вызвовов
* Улучшить документацию
* Добавить стракты(?)
* Добавить возможность броадкаста транзакций

# Golos

Elixir websockets client for interaction with GOLOS nodes. Provides an interface to Golos JSONRPC protocol. Golos is a supervised application, so don't forget to add it to applications in mix.exs.

## Installation

  1. Add `golos` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ex_golos, "~> 0.6.0"}]
    end
    ```

  2. Add 'golos' to applications in `mix.exs`:
    ```elixir
    def application do
      [applications: [:logger, :golos]]
    end
    ```

## Example

First, configure a websockets url for the golosd instance, for example, `http://127.0.0.1:8090` to the config.

```elixir
config :golos,
  url: "GOLOS_URL"
```

The most imporant module function is `Golos.call`. It will block the calling process and return a success tuple with a "result" data from the JSONRPC call response. JSONRPC call ids are handled automatically.


## Roadmap

Golos is under active development.

* Implement subscriptions
* Investigate using GenStage
* Add more utility functions
* Add more types and structs
* Add more tests and docs
* Add transaction broadcast
