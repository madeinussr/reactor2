collection @transaction_packs

attributes :guid, :user_guid
child(:transactions) {attributes :guid, :action, :table, :row_id, :attrs, :handled}