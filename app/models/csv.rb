class Csv < ActiveRecord::Base
	attr_accessible :csv_name, :file

	mount_uploader :file, FileUploader

	require 'nokogiri'

	def self.columns() 
  		@columns ||= []
	end

	def self.column(name, sql_type = nil, default = nil, null = true)
	  	columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
	end

	column :csv_name, :string
	column :file, :string

	def csv_from_html
		page = Nokogiri::HTML(self.file.file.read)
		header =  ["Policy Unit ID", "Subscriber Name", "Source Subscriber Identifier", "Payer Subscriber Identifier", 
		"Member Name", "Role", "Source Memeber Identifier", "Payer Memeber Identifier", "Error ID", "Error Message", "Intake Value", "Local Value"]

		CSV.generate do |writer|
			writer << header
			page.css("body table").each_with_index do |table, index|
				if index != 0
					policy_unit_id = table.css("tr")[1].css("td")[1].text
					subscriber_name = table.css("tr")[2].css("td")[1].text
					source_subscriber_identifier = table.css("tr")[3].css("td")[1].text
					payer_subscriber_identifier = table.css("tr")[4].css("td")[1].text
					table.css("tr")[7..-2].each do |value|
						member_name = value.css("td")[0].text
						role = value.css("td")[1].text.to_s
						source_member_identifier = value.css("td")[2].text
						payer_member_identifier = value.css("td")[3].text
						error_id = value.css("td")[4].text
						error_message = value.css("td")[5].text
						intake_value = value.css("td")[6].text
						local_value = value.css("td")[7].text
						row = [policy_unit_id, subscriber_name, source_subscriber_identifier, payer_subscriber_identifier, member_name, role, 
							source_member_identifier, payer_member_identifier, error_id, error_message, intake_value, local_value]
						#row = policy_unit_id + ", " + subscriber_name + ", " + source_subscriber_identifier + ", " + payer_subscriber_identifier + ", " + 
						#member_name + ", " +  role + ", " + source_member_identifier + ", " + payer_member_identifier + ", " + error_id + ", " + error_message + ", " 
						#+ intake_value + ", " + local_value
						writer << row
					end
				end
			end
	  	end
	end

	def csv_from_xml
		page = Nokogiri::XML(self.file.file.read)

		puts "Converting to XML!"
		puts "Page.class: " + page.class.to_s

		header =  ["Case ID", "ID", "Title", "Reported Information", "Status", "Type", "Priority", "Resolution", "Work Log", "Show in Portal",
		"Account ID", "Assigned User ID", "Teams", "Team ID", "Team Set", "Create Date", "Date Modified", "Created By ID", "Modified By ID",
		"Deleted", "Assigned Date", "Status Date", "Priority Date", "Resolution Note", "Note Date", "Discrepancy Category",
		"Final Findings", "Recommended Corrective Action", "Correction Category", "Linked To", "Resolved Date", "Originated From", 
		"Originated Impact Assessment", "Request Timestamp", "Target Completion Date", "Special Issue", "Maintenance Type", 
		"Red", "Yellow", "Troubleshooting Notes", "Origination ID", "Trading Partner ID", "Subscriber ID", "Member ID", "Policy ID", 
		"archive_flag", "Linked Case ID", "Issuer ID"]

		CSV.generate do |writer|
			writer << header

			puts "Header = " + writer.to_s
			page.xpath("//eackucf:AcknowledgementBatch").each_with_index do |acknowledgement_batch, index|
		if index != 0
			subscriber_id = acknowledgement_batch.xpath("//eackucf:RelatedEntity//ucfd:ExternalPrimaryIdentifier//ucf:Identifier")[index].attribute("value").value
			issuer_id = acknowledgement_batch.xpath("//eackucf:RelatedEntity//ucfd:ExternalSecondaryIdentifier//ucf:Identifier")[index].attribute("value").value
				
			#acknowledgement_batch.xpath("eackucf:AcknowledgementItem").each do |acknowledgement_item|
				case_id = ""
				id = ""
				title = ""

				error_id = "ErrorID: " + acknowledgement_batch.xpath("//eackucf:StatusAcknowledgement//ucfd:StatusDetail//ucf:ErrorID")[index-1].attribute("value").value.to_s + "|"
				severity = "Severity: " + acknowledgement_batch.xpath("//eackucf:StatusAcknowledgement//ucfd:StatusDetail//ucf:Severity")[index-1].attribute("value").value.to_s + "|"
				pre_error_data = "PreErrorData: " + acknowledgement_batch.xpath("//eackucf:StatusAcknowledgement//ucfd:StatusDetail//ucf:PreErrorData")[index-1].attribute("value").value.to_s + "|"
				post_error_data = "PostErrorData: " + acknowledgement_batch.xpath("//eackucf:StatusAcknowledgement//ucfd:StatusDetail//ucf:PostErrorData")[index-1].attribute("value").value.to_s
				biz_error_message = "BizErrorMessage: " + acknowledgement_batch.xpath("//eackucf:StatusAcknowledgement//ucfd:StatusDetail//ucf:BizErrorMessage")[index-1].attribute("value").value.to_s + "|"
				
				reported_information = error_id + severity + biz_error_message + pre_error_data + post_error_data
				status = ""
				type = ""
				priority = "U"
				resolution = ""
				work_log = ""
				show_in_portal = 0
				account_id = ""
				assigned_user_id = ""
				teams = ""
				team_id = 1
				team_set = 1
				create_date = Date.today
				date_modified = Date.today
				created_by_id = ""
				modified_by_id = ""
				deleted = 0
				assigned_date = Date.today
				status_date = Date.today
				priority_date = Date.today
				resolution_note = ""
				note_date = Date.today
				discrepancy_category = ""
				final_findings = ""
				reccommended_corrective_action = ""
				correction_category = "RPC"
				linked_to = ""
				resolved_date = ""
				originated_from = "ER"
				originated_impact_assessment = ""
				request_timestamp = Date.today
				target_completion_date = ""
				special_issue = 0
				maintenance_type = ""
				red = "N"
				yellow = "N"


				role = "Role: " + acknowledgement_batch.xpath("//eackucf:AcknowledgementItem/eackucf:Type")[1].attribute("value").value
				payer_member_id = "PayerMemberID: " + acknowledgement_batch.xpath("//eackucf:BusinessItem//eackucf:RelatedEntity//ucfd:Identification//ucfd:ExternalSecondaryIdentifier//ucf:Identifier")[index-1].attribute("value").value
				subscriber_name = "SubscriberName: " + acknowledgement_batch.xpath("//eackucf:BusinessItem//eackucf:RelatedEntity//ucfd:FirstName")[index-1].attribute("value").value + " " + acknowledgement_batch.xpath("//eackucf:BusinessItem//eackucf:RelatedEntity//ucfd:LastName")[index-1].attribute("value").value

				troubleshooting_notes = role + "|" + payer_member_id + "|" + subscriber_name
				origination_id = acknowledgement_batch.xpath("eackucf:ControlNumber").attribute("value").value
				trading_partner_id = "" 
				member_id = acknowledgement_batch.xpath("//eackucf:BusinessItem//eackucf:RelatedEntity//ucfd:Identification//ucfd:ExternalPrimaryIdentifier//ucf:Identifier")[index-1].attribute("value").value
				policy_id = acknowledgement_batch.xpath("eackucf:ControlNumber").attribute("value").value
				archive_flag = ""
				linked_case_id = ""
				row = [case_id, id, title, reported_information, status, type, priority, resolution, work_log, 
					show_in_portal, account_id, assigned_user_id, teams, team_id, team_set, create_date, date_modified, 
					created_by_id, modified_by_id, deleted, assigned_date, status_date, priority_date, resolution_note, 
					note_date, discrepancy_category, final_findings, reccommended_corrective_action, correction_category,
					linked_to, resolved_date, originated_from, originated_impact_assessment, request_timestamp, 
					target_completion_date, special_issue, maintenance_type, red, yellow, troubleshooting_notes, 
					origination_id, trading_partner_id, subscriber_id, member_id, policy_id, archive_flag, linked_case_id,
					issuer_id] 
				writer << row
			#end
		end
	end
		end
	end
end
