namespace :embargo_manager do
  desc 'Starts EmbargoWorker to manage expired embargoes'
  task :release => :environment do

    #Controls when reminder emails are sent out for expiring embargoed works.
    FOURTEEN_DAYS = 14
    THIRTY_DAYS = 30
    ZERO_DAYS = 0
    results_cap = 1000000

    solr_results = ActiveFedora::SolrService.query( 'embargo_release_date_dtsi:[* TO *]', rows: results_cap )
    solr_results.each do |work|

      days_until_release = (Date.parse(work['embargo_release_date_dtsi']) - Date.today).to_i

      receiver = work['depositor_tesim']      
      mail_contents = work['title_tesim'].first

      case days_until_release
      when ZERO_DAYS
        EmbargoMailer.notify(receiver, mail_contents, ZERO_DAYS)
      when FOURTEEN_DAYS
        EmbargoMailer.notify(receiver, mail_contents, FOURTEEN_DAYS)
      when THIRTY_DAYS
        EmbargoMailer.notify(receiver, mail_contents, THIRTY_DAYS)
      end
    end
  end
end
