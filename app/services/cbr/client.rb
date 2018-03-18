# Module of Central Bank of Russia
module CBR
  # Savon client
  class Client
    URI = 'http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx?WSDL'

    attr_reader :client

    def initialize
      @client = Savon.client(wsdl: URI, log: false)
    end

    def get_curs_on_date(date)
      return [] unless date

      response = client.call(:get_curs_on_date_xml,
                             message: { 'On_date' => date.strftime('%Y-%m-%d') })
      response.body.dig(:get_curs_on_date_xml_response,
                        :get_curs_on_date_xml_result,
                        :valute_data,
                        :valute_curs_on_date)
    end

    class << self
      def last_curs(currency)
        current_curses = new.get_curs_on_date(Time.zone.now)
        hash = current_curses.find { |x| x[:vch_code].downcase.to_sym == currency.downcase.to_sym }
        (hash || {})[:vcurs].to_f
      end
    end
  end
end
