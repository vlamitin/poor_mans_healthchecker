include .env

$(shell [ -f checks.txt ] || touch checks.txt)

.PHONY: check
.SILENT: check
check:
 (curl -s $(URL_TO_CHECK) > /dev/null || (make write_fail && exit 1)) && make write_success

.PHONY: write_success
.SILENT: write_success
write_success:
 $(shell [ "$$(tail -n 1 checks.txt | cut -d ' ' -f2)" = "success" ] || (make notify_success && printf "%s %s\n" $$(date +%s) "success" >> checks.txt))

.PHONY: write_fail
.SILENT: write_fail
write_fail:
 $(shell [ "$$(tail -n 1 checks.txt | cut -d ' ' -f2)" = "fail" ] || (make notify_fail && printf "%s %s\n" $$(date +%s) "fail" >> checks.txt))

.PHONY: notify_success
.SILENT: notify_success
notify_success:
 curl -X POST \
         -H 'Content-Type: application/json' \
         -d '{"chat_id": "$(TG_CHAT_ID)", "text": "✅ $(APP_NAME) ($(URL_TO_CHECK))", "disable_notification": true}' \
         https://api.telegram.org/bot$(TG_BOT_TOKEN)/sendMessage

.PHONY: notify_fail
.SILENT: notify_fail
notify_fail:
 curl -s -X POST \
         -H 'Content-Type: application/json' \
         -d '{"chat_id": "$(TG_CHAT_ID)", "text": "❌ $(APP_NAME) ($(URL_TO_CHECK))", "disable_notification": true}' \
         https://api.telegram.org/bot$(TG_BOT_TOKEN)/sendMessage

.PHONY: print_chat_ids
.SILENT: print_chat_ids
print_chat_ids:
 curl -s "https://api.telegram.org/bot$(TG_BOT_TOKEN)/getUpdates" | jq '.result' | jq 'map(select(.my_chat_member))' | jq 'map( { (.my_chat_member.chat.title): (.my_chat_member.chat.id) } )'
