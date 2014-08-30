module AresMUSH
  module Status    
    class AfkCronHandler
      include Plugin
      
      def on_cron_event(event)
        config = Global.config['status']['afk']
        return if !Cron.is_cron_match?(config['cron'], event.time)
        
        Global.client_monitor.logged_in_clients.each do |client|
          minutes_before_afk = config['minutes_before_afk']
          if (!minutes_before_afk.nil? && 
            !client.char.is_afk &&
            (client.idle_secs > minutes_before_afk * 60))
              client.emit_ooc t('status.auto_afk')
              client.char.is_afk = true
              client.char.save
          end
          
          minutes_before_idle_disconnect = config['minutes_before_idle_disconnect']
          if (!minutes_before_idle_disconnect.nil? &&
            (client.idle_secs > minutes_before_idle_disconnect * 60))
            client.emit_ooc t('status.afk_disconnect')
            client.disconnect
          end
        end
      end
    end    
  end
end