# Module of Central Bank of Russia
module CBR
  # Savon client
  class Client
    attr_reader :client

    def initialize
      @client = Savon.client do
        wsdl Rails.root.join('lib', 'cbr.wsdl')
        log Rails.env.development?
        logger Rails.logger
        pretty_print_xml true
      end
    end

    def get_curs_on_date(date)
      return [] unless date

      response = client.call(:get_curs_on_date_xml,
                             message: { 'On_date' => date.strftime('%Y-%m-%d') })
      response.body.dig(:get_curs_on_date_xml_response,
                        :get_curs_on_date_xml_result,
                        :valute_data,
                        :valute_curs_on_date)
    rescue Savon::HTTPError => e
      Rails.logger.error e.message
      []
    end

    class << self
      def last_curses
        current_curses = new.get_curs_on_date(Time.zone.now)
        current_curses.map { |h| [h[:vch_code].downcase, { currency: h[:vch_code].downcase, rate: h[:vcurs].to_f, nom: h[:vnom] }] }
                      .to_h
                      .with_indifferent_access
      end

      def last_curs(currency)
        last_curses[currency.to_s.downcase]
      end
    end
  end
end
