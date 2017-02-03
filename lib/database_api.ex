defmodule Golos.DatabaseApi do

  def call(method, params) do
    Golos.call(["database_api", method, params])
  end

  @doc """
  %{"extensions" => [], "previous" => "0004cb2eff2f45b042e85563f76f24123b6dfdd2",
  "timestamp" => "2016-10-29T09:23:33",
  "transaction_merkle_root" => "8477010d8f8ade6f69744c6c28203f1b4a1690a2",
  "transactions" => [%{"expiration" => "2016-10-29T09:23:42",
     "extensions" => [],
     "operations" => [["comment",
       %{"author" => "kriptograf",
         "body" => "@@ -187,16 +187,17 @@\n %D1%81%D1%82%D0%BE%D1%80%D0%B0%D0%BC%D0%B8 \n+%0A\n ( %D1%81%D1%83%D0%BC%D0%BC%D1%8B \n",
         "json_metadata" => "{\"tags\":[\"ru--kriptovalyuty\"]}",
         "parent_author" => "sept",
         "parent_permlink" => "kak-kupit-bitkoin-s-minimalnoi-komissiei",
         "permlink" => "re-sept-kak-kupit-bitkoin-s-minimalnoi-komissiei-20161029t091207449z",
         "title" => ""}]], "ref_block_num" => 51994,
     "ref_block_prefix" => 2572860361,
     "signatures" => ["207fe62d3e6582819a24f5c2258a9d74f69ebab6c9a42b4d321fe08e559b4cd13b6486a429cb60176d40a5d46ee8b8e30b5c6c24d8facc2a7a779ade3f9139a470"]}],
  "witness" => "misha",
  "witness_signature" => "2047ea30c48247a67ff553986f221092d32985eea3e341d684f2d4c0aa09a0ec402582b06619fc5dc40192e2c311eeea3c}
  """
  def get_block(height) do
    call("get_block", [height])
  end

  @doc """
  Get content by author and permlink.

  Example response:
    %{"max_accepted_payout" => "1000000.000 GBG",
    "title" => "[объявление] Краудсейл и Шэрдроп. Дистрибьюция",
    "category" => "ru--kraudseijl", "promoted" => "0.000 GBG",
    "last_update" => "2016-12-06T15:36:54", "created" => "2016-12-05T16:43:03",
    "parent_permlink" => "ru--kraudseijl", "total_vote_weight" => 0,
    "json_metadata" => "{\"tags\":[\"ru--kraudseijl\",\"ru--shyerdrop\",\"ru--golos\"],\"users\":[\"golos\",\"crowdsale\",\"cyberdrop\",\"misha\",\"ether\",\"bender\",\"hipster\",\"litvintech\",\"vitaly-lvov\"],\"image\":[\"https://dl.dropboxusercontent.com/u/52209381/golos/golos.png\",\"https://dl.dropboxusercontent.com/u/52209381/golos/Screenshot%202016-12-05%2018.30.00.png\",\"https://dl.dropboxusercontent.com/u/52209381/golos/ico_final-min.jpg\",\"https://dl.dropboxusercontent.com/u/52209381/golos/Screenshot%202016-12-06%2002.25.05.png\",\"https://dl.dropboxusercontent.com/u/52209381/golos/card.png\"],\"links\":[\"https://docs.google.com/spreadsheets/d/1JwCAeRwsu4NzCG20UDM_CnEEsskl0wtvQ7VYjqi233A/edit?usp=sharing\",\"https://golos.io/@litvintech\"]}",
    "last_payout" => "2017-01-15T11:00:06",
    "total_payout_value" => "2412.784 GBG", "allow_replies" => true,
    "children_rshares2" => "0", "id" => "2.8.30160",
    "pending_payout_value" => "0.000 GBG", "children" => 15, "replies" => [],
    "body" => "![wow](https://dl.dropboxusercontent.com/u/52209381/golos/golos.png)\n\n**Добрый день. В данный момент начинается дистрибьюция токенов Голоса**\n\n### 19.00 МСК - Шэрдроп. Начало дистрибьюции\n1. В соответствии с данной таблицей переведено 333 818 Голосов с аккаунта @golos на аккаунт @crowdsale, а также 300 Голосов в Силу Голоса для осуществления транзакций.\n**Баланс аккаунта: 27 405 818 Голосов**\n2. В соответствии с этой же таблицей переведено 97 356 Голосов с аккаунта @golos на аккаунт @cyberdrop, а также 200 Голосов в Силу Голоса для осуществления транзакций. Баланс аккаунта составил 10% от общего количества токенов. Так как после генезиса аккаунтам, которые попали в шэрдроп на генезис, было переведено 5 Голосов в Силу Голоса (в качестве регистрации), то с этого аккаунта обратно на @golos было переведено 41 720 Голосов в Голосах.\n**Баланс аккаунта: 4 535 096 Голосов**\n3. Переведено 197 134 Голосов в Силу Голоса @misha - последняя часть вознаграждения как сооснователя Голоса. \n\n\n![progress](https://dl.dropboxusercontent.com/u/52209381/golos/Screenshot%202016-12-05%2018.30.00.png)\n\n4. Запущено два скрипта для процессинга результатов краудсейла, которые подготовили две группы в команде разработчиков. Процесс займет около четырех-пяти часов. После результаты будут провалидированны всей командой основателей и опубликованы в этом посте.\n5. Запущен скрипт для распределения Силы Голоса по результатам шэрдропа. С аккаунта @cyberdrop в данный момент переводится 4 525 543 Голосов в Силу Голоса 4551 аккаунт. \n\n### 00.00 МСК - Шэрдроп. Конец дистрибьюции\n1. Закончена дистрибьюция шэрдроп Голосов в Силу Голоса 4551 аккаунтам. \nОстальные аккаунты, 3823, по расчетам, должны были получить меньше пяти Голосов - и им было начислено по 5 Голосов в Силу Голоса на старте сети. Перечислены 9551 Голос обратно на аккаунт @golos, в связи с перерасчетом в большую сторону при проведении дополнительной транзакции с @golos на @cyberdrop.\n\n2. Получено два снэпшота краудсейла. Сейчас команда обрабатывает данные, происходит кросс-валидация. В течении двух часов будет подготовлен массив транзакций по результатам краудсейла.\n\n* обновлено количество аккаунтов, а также токенов на правильные значения в соответствующие моменты времени\n\n* 6 декабря, около начало второго по МСК, **в блоке 1 411 200 включается Вестинг**\n\n* обнаружен аккаунт  @ether, который записал в свой json_metadata ico_address аккаунта @bender, соответственно @ether не участвовал в краудсейле\n\n* решена инфраструктурная проблема, которая приводила к перебоям в работе сайта\n\n### 03.00 МСК\n**[Результаты краудсейла. Таблица с дистрибьюцией. Список транзакций на ICO Голос](https://docs.google.com/spreadsheets/d/1JwCAeRwsu4NzCG20UDM_CnEEsskl0wtvQ7VYjqi233A/edit?usp=sharing)**\n\n### 03.15 МСК - Краудсейл. Начало дистрибьюции \n![ico final](https://dl.dropboxusercontent.com/u/52209381/golos/ico_final-min.jpg)\n**Запуск дистрибьюции @hipster @litvintech @vitaly-lvov**\n\n![start](https://dl.dropboxusercontent.com/u/52209381/golos/Screenshot%202016-12-06%2002.25.05.png)\n**Начало дистрибьюции Голосов в Силу Голоса инвесторам краудсейла.**\n\n### 04.30 МСК - Сделано 50% транзакций \n\n### 05.05 МСК - Сделано 75% транзакций\n\n### 05.15 МСК - Сделано 100% транзакций. Дистрибьюция закончена.\n* сделан снэпшот блокчейна\n\n**Да прибудет с вами Сила!**\n\n**Краудсейл окончен.**\n\nВнимание. Сейчас в личном кабинете вы видите расчет по краудсейлу и количество токенов, которые сейчас не актуальна. Актуальные данные о вашем количестве токенов вы можете увидеть (и проверить) в **[данной таблице](https://docs.google.com/spreadsheets/d/1JwCAeRwsu4NzCG20UDM_CnEEsskl0wtvQ7VYjqi233A/edit?usp=sharing)**.\n\n[![follow litvintech](https://dl.dropboxusercontent.com/u/52209381/golos/card.png)](https://golos.io/@litvintech)",
    "active" => "2016-12-06T22:23:06", "net_rshares" => 0,
    "author_rewards" => 10011558, "total_pending_payout_value" => "0.000 GBG",
    "root_comment" => "2.8.30160", "max_cashout_time" => "1969-12-31T23:59:59",
    "root_title" => "[объявление] Краудсейл и Шэрдроп. Дистрибьюция",
    "allow_votes" => true, "percent_steem_dollars" => 10000,
    "children_abs_rshares" => 0, "net_votes" => 90, "author" => "litvintech",
    "curator_payout_value" => "112.100 GBG",
    "permlink" => "obyavlenie-kraudseil-i-sherdrop-distribyuciya",
    "url" => "/ru--kraudseijl/@litvintech/obyavlenie-kraudseil-i-sherdrop-distribyuciya",
    "cashout_time" => "2017-02-14T11:00:06", "parent_author" => "",
    "allow_curation_rewards" => true, "vote_rshares" => 0,
    "reward_weight" => 10000,
    "active_votes" => [%{"percent" => 1000, "reputation" => "15928643268388",
       "rshares" => "1974529666496", "time" => "2016-12-05T17:02:39",
       "voter" => "val", "weight" => "99631990926249375"}, %{...}, ...], "depth" => 0,
    "mode" => "second_payout", "abs_rshares" => 0,
    "author_reputation" => "22784203010137"}
  """
  @spec get_content(String.t, String.t) :: map
  def get_content(author, permlink) do
    call("get_content", [author, permlink])
  end

  @doc """
  Get account data. Accepts either a list with up to 1000 account names

  Example response:
  [%{"recovery_account" => "cyberfounder", "posting_rewards" => 6041772,
  "created" => "1970-01-01T00:00:00",
  "last_bandwidth_update" => "2017-02-03T07:44:33",
  "to_withdraw" => "5358033161499672",
  "last_active_proved" => "1970-01-01T00:00:00", "withdraw_routes" => 0,
  "last_account_update" => "2016-11-04T21:28:45",
  "sbd_last_interest_payment" => "2017-01-15T11:19:27",
  "json_metadata" => "{\"created_at\":\"GENESIS\",\"ico_address\":\"1FNnNWE3m4rsMWTaX76A4bN1uK4biERdVn\",\"user_image\":\"https://habrastorage.org/files/6b3/db5/587/6b3db55871e04985821e4c453a30c60c.jpg\"}",
  "active_challenged" => false, "vesting_balance" => "0.000 GOLOS",
  "last_vote_time" => "2017-02-03T07:44:33", "post_history" => [],
  "blog_category" => %{}, "market_history" => [], "id" => "2.2.1993",
  "vesting_shares" => "5405134010.995395 GESTS", "vote_history" => [],
  "reset_account" => "null", "sbd_balance" => "12877.442 GBG",
  "last_post" => "2017-02-03T07:42:09", "lifetime_vote_count" => 0,
  "savings_sbd_last_interest_payment" => "1970-01-01T00:00:00",
  "mined" => true, "owner_challenged" => false,
  "vesting_withdraw_rate" => "51519549.629804 GESTS",
  "active" => %{"account_auths" => [],
    "key_auths" => [["GLS5vdTX6auUFyUwWEyzXAXhqo6LkCeCKAG2Tr9QaohRurcBouzHR",
      1]], "weight_threshold" => 1}, "proxy" => "",
  "posting" => %{"account_auths" => [],
    "key_auths" => [["GLS574PtkDcrf5PE8QA8Uq1a4YLqer6vRT8WTgsxdYnx5LJDG7RCD",
      1]], "weight_threshold" => 1}, "last_root_post" => "2017-02-02T13:37:45",
  "savings_balance" => "0.000 GOLOS", "average_bandwidth" => 313586832,
  "last_account_recovery" => "1970-01-01T00:00:00",
  "next_vesting_withdrawal" => "2017-02-05T15:01:33", "can_vote" => true,
  "owner" => %{"account_auths" => [],
    "key_auths" => [["GLS6PturNHrX82R3b6ymKRksNWT9K3hPL377qGmgbwBn2W5zyZVtH",
      1]], "weight_threshold" => 1},
  "witness_votes" => ["aizensou", "aleksandraz", "arcange", "creator",
   "dark.sun", "dervish0", "dr2073", "good-karma", "jesta", "kuna", "lehard",
   ...], "reputation" => "24178458603348", "post_count" => 615,
  "last_owner_proved" => "1970-01-01T00:00:00",
  "sbd_seconds_last_update" => "2017-02-03T06:17:15",
  "memo_key" => "GLS8dEWEGYtZj8hvcm7NVZjQKy637F2UMUK9RMMJKW4TowPX7FWFS",
  "name" => "hipster", "withdrawn" => "103039099259608",
  "savings_withdraw_requests" => 0,
  "reset_request_time" => "1969-12-31T23:59:59", "savings_sbd_seconds" => "0",
  "last_owner_update" => "2016-10-18T11:19:12", ...},
  %{...}]
  """
  @spec get_accounts([String.t]) :: [map]
  def get_accounts(accounts) when is_list(accounts) do
    call("get_accounts", [accounts])
  end

  @doc """
  Get block header data. Accepts block height.
  """
  @spec get_block_header(pos_integer) :: map
  def get_block_header(height) do
    call("get_block_header", [height])
  end

  @doc """
  Unsurprisingly returns a map with dynamic global propeties.
  """
  @spec get_dynamic_global_properties() :: map
  def get_dynamic_global_properties do
    call("get_dynamic_global_properties", [])
  end

  @doc """
  Unsurprisingly returns a map with chain propeties.
  """
  @spec get_chain_properties() :: map
  def get_chain_properties do
    call("get_chain_properties", [])
  end

  @doc """
  Return feed history
  """
  @spec get_feed_history() :: map
  def get_feed_history do
    call("get_feed_history", [])
  end

  def get_current_median_history_price do
    call("get_current_median_history_price", [])
  end

  # ACCOUNTS
  def get_account_count() do
   call("get_account_count", [])
  end

  def lookup_accounts(lower_bound_name, limit) do
   call("lookup_accounts", [lower_bound_name,  limit])
  end

  def lookup_account_names(account_names) do
   call("lookup_account_names", [account_names])
  end

end
