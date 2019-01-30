<!---
	Original Code obtained from http://code.google.com/p/cffedexrates/downloads
	Modified to fit a more component oriented approach and updated to v10 of the Fedex web API
--->
<cfcomponent>
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="false" default="kWhKnYkhtKKczD0e">
		<cfargument name="password" type="string" required="false" default="EpsGvfevuY8DR1Vu7F6KSAoFm">
		<cfargument name="accountNo" type="string" required="false" default="353854194">
		<cfargument name="meterNo" type="string" required="false" default="105410320">
		<cfargument name="sandbox" type="boolean" required="false" default="false">
	
		<cfset variables.key = arguments.key />
		<cfset variables.password = arguments.password />
		<cfset variables.accountNo = arguments.accountNo />
		<cfset variables.meterNo = arguments.meterNo />
		
		<cfif arguments.sandbox>
			<cfset variables.fedexUrl = "https://wsbeta.fedex.com/web-services">
		<cfelse>
			<cfset variables.fedexUrl = "https://ws.fedex.com/web-services">
		</cfif>
	
		<cfreturn this />
	</cffunction>

	<cffunction name="getRates" access="public" returntype="struct" output="true">
		<!---Ship To (Recipient) Details--->
		<cfargument name="shipToContact" type="string" default="" />
		<cfargument name="shipToAddress1" type="string" default="" />
		<cfargument name="shipToAddress2" type="string" default=""/>
		<cfargument name="shipToCity" type="string" default="" />
		<cfargument name="shipToState" type="string" default="" />
		<cfargument name="shipToZip" type="string" required="false" default="" />
		<cfargument name="shipToUrbCode" type="string" default="" hint="Applies to Puerto Rico only" />
		<cfargument name="shipToCountry" type="string" required="no" default="" />
		<cfargument name="shipToResidential" type="boolean" required="no" default="true" />
		<!---Package Details--->
		<cfargument name="pkgWeight" type="string" required="yes" />
		<cfargument name="totalWeight" type="numeric" required="no" />
		<cfargument name="pkgValue" type="string" default="" />
		<cfargument name="totalPkgValue" type="numeric" required="no" />
		<cfargument name="pkgLength" type="numeric" required="no" default="0" />
		<cfargument name="pkgWidth" type="numeric" required="no" default="0" />
		<cfargument name="pkgHeight" type="numeric" required="no" default="0" />
		<cfargument name="pkgWeightUnits" type="string" required="no" default="kg" />
		<cfargument name="pkgSizeUnits" type="string" required="no" default="cm" />
		<!---Extra Options--->
		<cfargument name="returnRawResponse" type="boolean" required="no" default="false" />
		<!---Shipper (Sender) Details--->
		<cfargument name="shipperAddress1" type="string" default="#application.shipperAddress#" />
		<cfargument name="shipperAddress2" type="string" default="#application.shipperAddress2#" />
		<cfargument name="shipperCity" type="string" default="#application.shipperCity#" />
		<cfargument name="shipperState" type="string" default="#application.shipperState#" />
		<cfargument name="shipperZip" type="string" required="no" default="#application.shipperZip#" />
		<cfargument name="shipperUrbCode" type="string" default="" hint="Applies to Puerto Rico only" />
		<cfargument name="shipperCountry" type="string" required="no" default="#application.shipperCountry#" />

		<cfset var XMLPacket = "" />
		<cfset var xmlFile = "" />
		<cfset var cfhttp = "" />
		<cfset var err= false />
		<cfset var fedexReply	= "" />
		<cfset var n= "" />
		<cfset var r= "" />
		<cfset var s= "" />
		<cfset var counter= "1" />
		<cfset var i= "" />

		<!--- Verify list of weights is all numeric --->		
		<cfif reFind("[^0-9,\. ]", arguments.pkgWeight)>
			<cfthrow message="Invalid PkgWeight list. One or more of the values is not numeric [#arguments.pkgWeight#]" />
		</cfif>		
		<!--- Verify list of insured amounts is all numeric --->		
		<cfif reFind("[^0-9,\. ]", arguments.pkgValue)>
			<cfthrow message="Invalid PkgValue list. One or more of the values is not numeric [#arguments.pkgValue#]" />
		</cfif>		
		<!--- If supplied, ensure the number of values match the number of weights --->
		<cfif listLen(trim(arguments.pkgValue))>
			<cfif listLen(arguments.pkgWeight) neq listLen(arguments.pkgValue)>
				<cfthrow message="PkgWeight and PkgValue lists do not contain the same number of elements: PkgWeight (#listLen(arguments.pkgWeight)#) PkgValue (#listLen(arguments.pkgValue)#) " />
			</cfif>		
		</cfif>		
		<cftry>
			<!---Build the XML Packet to send to FedEx--->
			<cfsavecontent variable="XMLPacket"><cfoutput>
			<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:v13="http://fedex.com/ws/rate/v13">
			<SOAP-ENV:Body>
				<!--- // <ns:RateRequest>
					<ns:WebAuthenticationDetail>
						<ns:UserCredential>
							<ns:Key>#variables.key#</ns:Key>
							<ns:Password>#variables.password#</ns:Password>
						</ns:UserCredential>
					</ns:WebAuthenticationDetail>
					<ns:ClientDetail>
						<ns:AccountNumber>#variables.accountNo#</ns:AccountNumber>
						<ns:MeterNumber>#variables.meterNo#</ns:MeterNumber>
					</ns:ClientDetail>
				  <ns:Version>
				      <ns:ServiceId>crs</ns:ServiceId>
				      <ns:Major>10</ns:Major>
				      <ns:Intermediate>0</ns:Intermediate>
				      <ns:Minor>0</ns:Minor>
				  </ns:Version>
					<ns:RequestedShipment>
						<ns:ShipTimestamp>#DateFormat(Now(),'yyyy-mm-dd')#T#TimeFormat(Now(),'hh:mm:ss')#</ns:ShipTimestamp>
						<ns:DropoffType>REGULAR_PICKUP</ns:DropoffType>
						<ns:PackagingType>YOUR_PACKAGING</ns:PackagingType>
						<cfif structKeyExists(arguments, "totalWeight")>
						<ns:TotalWeight>
							<ns:Units>kg</ns:Units>
							<ns:Value>#arguments.totalWeight#</ns:Value>
						</ns:TotalWeight>
						</cfif>
						<cfif structKeyExists(arguments, "totalPkgValue")>
						<ns:TotalInsuredValue>
							<ns:Currency>USD</ns:Currency>
							<ns:Amount>#arguments.totalPkgValue#</ns:Amount>
						</ns:TotalInsuredValue>
						</cfif>

						<ns:Shipper>
							<ns:Address>
								<ns:StreetLines/>
								<ns:City/>
								<ns:StateOrProvinceCode/>
								<ns:PostalCode>#arguments.shipperZip#</ns:PostalCode>
								<ns:CountryCode>#arguments.shipperCountry#</ns:CountryCode>
							</ns:Address>
						</ns:Shipper>
						<ns:Recipient>
							<ns:Address>
							    <ns:StreetLines/>
							    <ns:City/>
                                                            <ns:StateOrProvinceCode/>
							    <ns:PostalCode>#arguments.shipToZip#</ns:PostalCode>
							    <ns:CountryCode>#arguments.shipToCountry#</ns:CountryCode>
							</ns:Address>
						</ns:Recipient>
						<ns:RateRequestType>LIST</ns:RateRequestType>
						<ns:PackageCount>#listLen(arguments.pkgWeight)#</ns:PackageCount>
						<cfloop list="#arguments.pkgWeight#" index="i">
						<ns:RequestedPackageLineItems>
							<ns:SequenceNumber>#counter#</ns:SequenceNumber>
							<ns:GroupPackageCount>1</ns:GroupPackageCount>
							<cfif listLen(trim(arguments.pkgValue))>
							<ns:InsuredValue>
								<ns:Currency>USD</ns:Currency>
								<ns:Amount>#listGetAt(arguments.pkgValue, counter)#</ns:Amount>
							</ns:InsuredValue>
							</cfif>
							<ns:Weight>
								<ns:Units>kg</ns:Units>
								<ns:Value>#i#</ns:Value>
							</ns:Weight>
							<cfset counter = counter + 1>
						</ns:RequestedPackageLineItems>
						</cfloop>
					</ns:RequestedShipment>
				</ns:RateRequest> --->
			

			      <v13:RateRequest>
			         <v13:WebAuthenticationDetail>
			            <v13:UserCredential>
			               <v13:Key>#variables.key#</v13:Key>
			               <v13:Password>#variables.password#</v13:Password>
			            </v13:UserCredential>
			         </v13:WebAuthenticationDetail>
			         <v13:ClientDetail>
			           <v13:AccountNumber>#variables.accountNo#</v13:AccountNumber>
			            <v13:MeterNumber>#variables.meterNo#</v13:MeterNumber>
			         </v13:ClientDetail>
			         <v13:TransactionDetail>
			            <v13:CustomerTransactionId>Rate a Single Package v13</v13:CustomerTransactionId>
			         </v13:TransactionDetail>
			         <v13:Version>
			            <v13:ServiceId>crs</v13:ServiceId>
			            <v13:Major>13</v13:Major>
			            <v13:Intermediate>0</v13:Intermediate>
			            <v13:Minor>0</v13:Minor>
			         </v13:Version>
			         <v13:ReturnTransitAndCommit>1</v13:ReturnTransitAndCommit>
			         <v13:CarrierCodes>FDXE</v13:CarrierCodes>
			         <v13:RequestedShipment>
			            <v13:ShipTimestamp>#DateFormat(Now(),'yyyy-mm-dd')#T#TimeFormat(Now(),'hh:mm:ss')#</v13:ShipTimestamp>
			            <v13:DropoffType>REGULAR_PICKUP</v13:DropoffType>
			            <!--- <v13:ServiceType>PRIORITY_OVERNIGHT</v13:ServiceType> --->
			            <v13:PackagingType>YOUR_PACKAGING</v13:PackagingType>
			            <v13:Shipper>
			              <v13:AccountNumber></v13:AccountNumber>
			               <!--- <v13:Tins>
			                  <v13:TinType>PERSONAL_STATE</v13:TinType>
			                  <v13:Number>1057</v13:Number>
			                  <v13:Usage>ShipperTinsUsage</v13:Usage>
			               </v13:Tins>
			               <v13:Contact>
			                  <v13:ContactId>SY32030</v13:ContactId>
			                  <v13:PersonName>Sunil Yadav</v13:PersonName>
			                  <v13:CompanyName>Syntel Inc</v13:CompanyName>
			                  <v13:PhoneNumber>9545871684</v13:PhoneNumber>
			                  <v13:PhoneExtension>020</v13:PhoneExtension>
			                  <v13:EMailAddress>sunil_yadav3@syntelinc.com</v13:EMailAddress>
			               </v13:Contact> --->
			               <v13:Address>
			                  <v13:StreetLines>#arguments.shipperAddress1#</v13:StreetLines>
			                  <v13:StreetLines>#arguments.shipperAddress2#</v13:StreetLines>
			                  <v13:City>#arguments.shipToCity#</v13:City>
			                  <v13:StateOrProvinceCode>#arguments.shipToState#</v13:StateOrProvinceCode>
			                  <v13:PostalCode>#arguments.shipperZip#</v13:PostalCode>
			                  <!--- <v13:UrbanizationCode>CO</v13:UrbanizationCode> --->
			                  <v13:CountryCode>#arguments.shipperCountry#</v13:CountryCode>
			                  <v13:Residential>1</v13:Residential>
			               </v13:Address>
			            </v13:Shipper>
			            <v13:Recipient>
			               <v13:Contact>
			                  <v13:PersonName>#arguments.shipToContact#</v13:PersonName>
			                  <!---<v13:CompanyName>Receiver Org</v13:CompanyName>
			                  <v13:PhoneNumber>9982145555</v13:PhoneNumber>
			                  <v13:PhoneExtension>011</v13:PhoneExtension>
			                  <v13:EMailAddress>receiver@yahoo.com</v13:EMailAddress> --->
			               </v13:Contact>
			               <v13:Address>
			                  <v13:StreetLines>#arguments.shipToAddress1#</v13:StreetLines>
			                  <v13:StreetLines>#arguments.shipToAddress2#</v13:StreetLines>
			                  <v13:City>#arguments.shipToCity#</v13:City>
			                  <v13:StateOrProvinceCode>#arguments.shipToState#</v13:StateOrProvinceCode>
			                  <v13:PostalCode>#arguments.shipToZip#</v13:PostalCode>
			                  <!--- <v13:UrbanizationCode>CO</v13:UrbanizationCode> --->  
			                  <v13:CountryCode>#arguments.shipToCountry#</v13:CountryCode>
			                  <v13:Residential>1</v13:Residential>
			               </v13:Address>
			            </v13:Recipient>
			            <!--- v13:RecipientLocationNumber>DEN001</v13:RecipientLocationNumber> --->
			            <!--- <v13:Origin>
			               <v13:Contact>
			                  <v13:ContactId>SY32030</v13:ContactId>
			                  <v13:PersonName>Sunil Yadav</v13:PersonName>
			                  <v13:CompanyName>Syntel Inc</v13:CompanyName>
			                  <v13:PhoneNumber>9545871684</v13:PhoneNumber>
			                  <v13:PhoneExtension>020</v13:PhoneExtension>
			                  <v13:EMailAddress>sunil_yadav3@syntelinc.com</v13:EMailAddress>
			               </v13:Contact>
			               <v13:Address>
			                  <v13:StreetLines>SHIPPER ADDRESS LINE 1</v13:StreetLines>
			                  <v13:StreetLines>SHIPPER ADDRESS LINE 2</v13:StreetLines>
			                  <v13:City>COLORADO SPRINGS</v13:City>
			                  <v13:StateOrProvinceCode>CO</v13:StateOrProvinceCode>
			                  <v13:PostalCode>80915</v13:PostalCode>
			                  <v13:UrbanizationCode>CO</v13:UrbanizationCode>
			                  <v13:CountryCode>US</v13:CountryCode>
			                  <v13:Residential>0</v13:Residential>
			               </v13:Address>
			            </v13:Origin> --->
			            <!--- <v13:ShippingChargesPayment>
			               <v13:PaymentType>SENDER</v13:PaymentType>
			               <v13:Payor>
			                   <v13:ResponsibleParty>
			                        <v13:AccountNumber></v13:AccountNumber>
			                        <v13:Tins>
			                           <v13:TinType>BUSINESS_STATE</v13:TinType>
			                           <v13:Number>123456</v13:Number>
			                        </v13:Tins>
			                     </v13:ResponsibleParty>
			               </v13:Payor>
			            </v13:ShippingChargesPayment> --->
			            <v13:RateRequestTypes>LIST</v13:RateRequestTypes>
			            <v13:PackageCount>#listLen(arguments.pkgWeight)#</v13:PackageCount>
			            <cfloop list="#arguments.pkgWeight#" index="i">
			            <v13:RequestedPackageLineItems>
			               <v13:SequenceNumber>#counter#</v13:SequenceNumber>
			               <!--- <v13:GroupNumber>1</v13:GroupNumber> --->
			               <v13:GroupPackageCount>1</v13:GroupPackageCount>
			               <v13:Weight>
			                  <v13:Units>#uCase(arguments.pkgWeightUnits)#</v13:Units>
			                  <v13:Value>#i#</v13:Value>
			               </v13:Weight>
			               <v13:Dimensions>
			                  <v13:Length>#arguments.pkgLength#</v13:Length>
			                  <v13:Width>#arguments.pkgWidth#</v13:Width>
			                  <v13:Height>#arguments.pkgHeight#</v13:Height>
			                  <v13:Units>#uCase(arguments.pkgSizeUnits)#</v13:Units>
			               </v13:Dimensions>
			               <!--- <v13:PhysicalPackaging>BAG</v13:PhysicalPackaging>--->
			               <!--- <v13:ContentRecords>
			                  <v13:PartNumber>PRTNMBR007</v13:PartNumber>
			                  <v13:ItemNumber>ITMNMBR007</v13:ItemNumber>
			                  <v13:ReceivedQuantity>10</v13:ReceivedQuantity>
			                  <v13:Description>ContentDescription</v13:Description>
			               </v13:ContentRecords> --->
			            </v13:RequestedPackageLineItems>
			            <cfset counter = counter + 1>
			            </cfloop>
			         </v13:RequestedShipment>
			      </v13:RateRequest>
	 		</SOAP-ENV:Body>
			</SOAP-ENV:Envelope></cfoutput></cfsavecontent>

			<!--- send the request --->
			<cfhttp url="#variables.fedexurl#/rate" port="443" method ="POST"> 
				<cfhttpparam name="name" type="XML" value="#XMLPacket#" /> 
			</cfhttp>
			<!--- extract response from envelope body --->
			<cfset xmlFile = XmlParse(CFHTTP.FileContent).Envelope.Body />

			<!---Build the Struct for Return--->
			<cfset fedexReply = StructNew() />
			<cfset fedexReply.response = Arraynew(1) />
			
			<cfif arguments.returnRawResponse>
				<cfset fedexReply.rawResponse = CFHTTP.FileContent />
			</cfif>

			<!---Did you pass bad info or malformed XML?--->
			<cfif not isDefined('xmlFile.Fault')>
				
				<cfif xmlfile.RateReply.HighestSeverity.xmltext contains "Error"
					OR xmlfile.RateReply.HighestSeverity.xmltext contains "Warning"
					OR xmlfile.RateReply.HighestSeverity.xmltext contains "Failure">					
					<cfset err = true />
					<cfthrow message="Response error">
				</cfif>

				<cfloop from="1" to="#arrayLen(xmlfile.RateReply.Notifications)#" index="n">
					<cfset fedexReply.response[n] = structNew() />
					<cfset fedexReply.response[n].status = xmlfile.RateReply.Notifications[n].Severity.xmltext />
					<cfset fedexReply.response[n].msg = xmlfile.RateReply.Notifications[n].Message.xmltext />
				</cfloop>

				<!---Did FedEx reply with an error?--->
				<cfif NOT err>
					<!--- Extract rates --->
					<cfset fedexReply.rates = ArrayNew(1) />
					
					<cfloop from="1" to="#arrayLen(xmlfile.RateReply.RateReplyDetails)#" index="r">
						<cfset fedexReply.rates[r] = StructNew() />
						<cfset fedexReply.rates[r].type = xmlfile.RateReply.RateReplyDetails[r].ServiceType.xmltext />
						<cfset fedexReply.rates[r].totalBaseCharge = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.TotalBaseCharge.Amount.xmltext />
						<cfset fedexReply.rates[r].totalNetFreight = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.TotalNetFreight.Amount.xmltext />
						<cfset fedexReply.rates[r].totalSurcharges = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.TotalSurcharges.Amount.xmltext />
						<cfset fedexReply.rates[r].totalTaxes = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.TotalTaxes.Amount.xmltext />
						<cfset fedexReply.rates[r].totalRebates = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.TotalRebates.Amount.xmltext />
						<cfset fedexReply.rates[r].totalNetCharge = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.TotalNetCharge.Amount.xmltext />
						<cfset fedexReply.rates[r].deliveryTimeStamp = xmlfile.RateReply.RateReplyDetails[r].DeliveryTimeStamp.xmltext />
						<!--- Some accounts have surcharges --->
						<cfif structKeyExists(xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail, "Surcharges")>
							<cfset fedexReply.rates[r].surcharges = ArrayNew(1) />
							
							<cfloop from="1" to="#arrayLen(xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.Surcharges)#" index="s">
								<cfset fedexReply.rates[r].surcharges[s] = StructNew() />
								<cfset fedexReply.rates[r].surcharges[s].type = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.Surcharges[s].SurchargeType.xmltext />
								<cfset fedexReply.rates[r].surcharges[s].description = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.Surcharges[s].Description.xmltext />
								<cfset fedexReply.rates[r].surcharges[s].amount = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.Surcharges[s].Amount.Amount.xmltext />
							</cfloop>
						</cfif>
						
						<!--- Some accounts have discounts, if this account has a discount get it so we can add it to TotalNetCharge --->
						<cfif structKeyExists(xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails, "EffectiveNetDiscount")>
							<cfset fedexReply.rates[r].discount = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.EffectiveNetDiscount.Amount.xmltext />
							<cfset fedexReply.rates[r].total = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.EffectiveNetDiscount.Amount.xmltext + xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.TotalNetCharge.Amount.xmltext />
						<cfelse>
							<cfset fedexReply.rates[r].discount = 0 />
							<cfset fedexReply.rates[r].total = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.TotalNetCharge.Amount.xmltext />
						</cfif>
					</cfloop>
				</cfif>
			<cfelse>
				<cfset fedexReply.response = ArrayNew(1) />
				<cfset fedexReply.response[1] = structNew() />
				<cfset fedexReply.response[1].status = "Error" />
				<cfset fedexReply.response[1].msg = xmlFile.Fault.faultstring.xmltext />
					
				<cfset err = true />
			</cfif>
			
			<cfset fedexReply.success = NOT err />
		<cfcatch>
			<cfscript>
				if( isDefined("cfhttp.fileContent") ){
					msg = cfcatch.message & " response from call: #cfhttp.fileContent#";
				} else {
					msg = cfcatch.message;
				}
				application.services.tools.log(msg, cfcatch);
			</cfscript>
		</cfcatch>
		</cftry>
		
		<cfreturn fedexReply />
	</cffunction>
	
	<cffunction name="processShipmentRequest" access="remote" returntype="struct" output="false">
		<!--- From Address --->
		<cfargument name="shipperName" type="string" required="no" default="" />
		<cfargument name="shipperCompany" type="string" required="no" default="" />
		<cfargument name="shipperPhone" type="string" required="no" default="" />
		<cfargument name="shipperAddress1" type="string" required="no" default="" />
		<cfargument name="shipperAddress2" type="string" required="no" default="" />
		<cfargument name="shipperCity" type="string" required="no" default="" />
		<cfargument name="shipperState" type="string" required="no" default="" />
		<cfargument name="shipperZip" type="string" required="no" default="" />
		<cfargument name="shipperUrbCode" type="string" default="" hint="Applies to Puerto Rico only" />
		<cfargument name="shipperCountry" type="string" required="no" default="US" />
		<cfargument name="shipperIsResidential" type="boolean" required="no" default="false" />
		<!--- To Address --->		
		<cfargument name="shipToName" type="string" required="yes" />
		<cfargument name="shipToCompany" type="string" required="no" default="" />
		<cfargument name="shipToPhone" type="string" required="yes" />
		<cfargument name="shipToEmail" type="string" required="no" default="" />
		<cfargument name="shipToAddress1" type="string" required="yes" />
		<cfargument name="shipToAddress2" type="string" required="no" default="" />
		<cfargument name="shipToCity" type="string"required="yes" />
		<cfargument name="shipToState" type="string" required="yes" />
		<cfargument name="shipToZip" type="string" required="yes" />
		<cfargument name="shipToCountry" type="string" required="no" default="US" />
		<cfargument name="shipToResidential" type="boolean" required="no" default="false" />
		<!--- package Details --->
		<cfargument name="weight" type="string" required="yes" />
		<cfargument name="length" type="string" required="yes" />
		<cfargument name="width"  type="string" required="yes" />
		<cfargument name="height" type="string" required="yes" />
		<cfargument name="packagingType" type="string" required="yes" hint="Available Options : FEDEX_10KG_BOX, FEDEX_25KG_BOX, FEDEX_BOX, FEDEX_ENVELOPE, FEDEX_PAK, FEDEX_TUBE, YOUR_PACKAGING" />
		<!--- shipping details ---->
		<cfargument name="orderid" type="string" required="no" default="" />
		<cfargument name="shippingMethod" type="string" required="no" default="STANDARD_OVERNIGHT" hint="Available Options : EUROPE_FIRST_INTERNATIONAL_PRIORITY, FEDEX_1_DAY_FREIGHT, FEDEX_2_DAY, FEDEX_2_DAY_FREIGHT, FEDEX_3_DAY_FREIGHT, FEDEX_EXPRESS_SAVER, FEDEX_GROUND, FIRST_OVERNIGHT, GROUND_HOME_DELIVERY, INTERNATIONAL_ECONOMY, INTERNATIONAL_ECONOMY_FREIGHT, INTERNATIONAL_FIRST, INTERNATIONAL_PRIORITY, INTERNATIONAL_PRIORITY_FREIGHT, PRIORITY_OVERNIGHT, SMART_POST, STANDARD_OVERNIGHT" />
		<cfargument name="shipDate" type="string" required="no" default="#now()#" />
		<cfargument name="department" type="string" required="no" default="" />
		<cfargument name="ponumber" type="string" required="no" default="" />
		<cfargument name="dropoffType" type="string" required="no" default="REGULAR_PICKUP" hint="Available Options : REGULAR_PICKUP, REQUEST_COURIER, DROP_BOX, BUSINESS_SERVICE_CENTER, STATION" />
		<cfargument name="specialServices" type="string" required="no" default="" hint="Available Options : DANGEROUS_GOODS, BROKER_SELECT_OPTION, COD, DRY_ICE, ELECTRONIC_TRADE_DOCUMENTS, EMAIL_NOTIFICATION, FUTURE_DAY_SHIPMENT, HOLD_AT_LOCATION, HOME_DELIVERY_PREMIUM, INSIDE_DELIVERY, INSIDE_PICKUP, PENDING_SHIPMENT, RETURN_SHIPMENT, SATURDAY_DELIVERY, SATURDAY_PICKUP" />
		<cfargument name="dryIceWeight" type="string" required="no" default="" hint="Dry Ice Weight" />
		<!--- "Hold At" Location Address ---->
		<cfargument name="holdAtAddress1" type="string" required="no" default="" />
		<cfargument name="holdAtAddress2" type="string" required="no" default="" />
		<cfargument name="holdAtCity" type="string" required="no" default="" />
		<cfargument name="holdAtState" type="string" required="no" default="" />
		<cfargument name="holdAtZip" type="string" required="no" default="" />
		<cfargument name="holdAtPhone" type="string" required="no" default="" />
		<cfargument name="holdAtIsResident" type="string" required="no" default="false" />
		<!--- fedex Access Settings --->
		<cfargument name="billingAct" type="string" required="no" default="" />
		<cfargument name="billingCountry" type="string" required="no" default="US" />
		<cfargument name="paymentType" type="string" required="no" default="SENDER"  hint="Available Options : COLLECT, RECIPIENT, SENDER, THIRD_PARTY" />
		<!--- shipping label settings --->
		<cfargument name="imageType" type="string" required="no" default="PDF" hint="Available Options : DOC, DPL, EPL2, PDF, PNG, RTF, TEXT, ZPLII" />
		<cfargument name="labelDirectory" type="string" required="no" default="#ExpandPath('FedexPDF/')#" />
		<cfargument name="labelFileName" type="string" required="no" default="" hint="The label file name. Otherwise orderId will be used if provided" />
		<cfargument name="labelStockType" type="string" required="no" default="PAPER_4X6"  hint="Available Options : PAPER_4X6, PAPER_4X8, PAPER_4X9, PAPER_7X4.75, PAPER_8.5X11_BOTTOM_HALF_LABEL, PAPER_8.5X11_TOP_HALF_LABEL, STOCK_4X6, STOCK_4X6.75_LEADING_DOC_TAB, STOCK_4X6.75_TRAILING_DOC_TAB, STOCK_4X8, STOCK_4X9_LEADING_DOC_TAB, STOCK_4X9_TRAILING_DOC_TAB" />
		<!---Extra Options--->
		<cfargument name="returnRawResponse" type="boolean" required="no" default="false" />
			
		<cfset var XMLPacket = "" />
		<cfset var xmlFile = "" />
		<cfset var cfhttp = "" />
		<cfset var err = false />
		<cfset var fedexReply	= StructNew() />
		<cfset var fedexLabel = "" />
		<cfset var fileName = "" />
		<cfset var n = "" />
		<cfset var r = "" />
		<cfset var s = "" />
		<cfset var counter = 1 />
		<cfset var i = "" />

		<!---Build the XML Packet to send to FedEx--->
		<cfsavecontent variable="XMLPacket"><cfoutput>
		<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns="http://fedex.com/ws/ship/v10">
		<SOAP-ENV:Body>
			<ns:ProcessShipmentRequest>
				<ns:WebAuthenticationDetail>
					<ns:UserCredential>
						<ns:Key>#variables.key#</ns:Key>
						<ns:Password>#variables.password#</ns:Password>
					</ns:UserCredential>
				</ns:WebAuthenticationDetail>
				<ns:ClientDetail>
					<ns:AccountNumber>#variables.accountNo#</ns:AccountNumber>
					<ns:MeterNumber>#variables.meterNo#</ns:MeterNumber>
				</ns:ClientDetail>
				<cfif len(trim(arguments.orderid))>
				<ns:TransactionDetail>
					<ns:CustomerTransactionId>#arguments.orderid#</ns:CustomerTransactionId>
				</ns:TransactionDetail>
				</cfif>
			  <ns:Version>
			      <ns:ServiceId>ship</ns:ServiceId>
			      <ns:Major>10</ns:Major>
			      <ns:Intermediate>0</ns:Intermediate>
			      <ns:Minor>0</ns:Minor>
			  </ns:Version>
				<ns:RequestedShipment>
					<ns:ShipTimestamp>#dateformat(arguments.ShipDate,"yyyy-mm-dd")#T#TimeFormat(arguments.shipDate, "HH:mm:ss")#</ns:ShipTimestamp>
					<ns:DropoffType>#arguments.dropoffType#</ns:DropoffType>
					<ns:ServiceType>#trim(arguments.shippingMethod)#</ns:ServiceType>
					<ns:PackagingType>#trim(arguments.packagingType)#</ns:PackagingType>
				
					<ns:Shipper>
						<ns:Contact>
							<cfif len(trim(arguments.shipperName))>
								<ns:PersonName>#arguments.shipperName#</ns:PersonName>
							</cfif>
							<cfif len(trim(arguments.shipperPhone))>
								<ns:CompanyName>#arguments.shipperCompany#</ns:CompanyName>
							</cfif>
							<cfif len(trim(arguments.shipperPhone))>
								<ns:PhoneNumber>#arguments.shipperPhone#</ns:PhoneNumber>
							</cfif>
						</ns:Contact>
						<ns:Address>
						<cfif len(trim(arguments.shipperAddress1))>
							<ns:StreetLines>#arguments.shipperAddress1#</ns:StreetLines>
						</cfif>
						<cfif len(trim(arguments.shipperAddress2))>
							<ns:StreetLines>#arguments.shipperAddress2#</ns:StreetLines>
						</cfif>
						<cfif len(trim(arguments.shipperCity))>
							<ns:City>#arguments.shipperCity#</ns:City>
						</cfif>
						<cfif len(trim(arguments.shipperState))>
							<ns:StateOrProvinceCode>#arguments.shipperState#</ns:StateOrProvinceCode>
						</cfif>
							<ns:PostalCode>#arguments.shipperZip#</ns:PostalCode>
						<cfif len(trim(arguments.shipperUrbCode))>
							<ns:UrbanizationCode>#arguments.shipperUrbCode#</ns:UrbanizationCode>
						</cfif>
							<ns:CountryCode>#arguments.shipperCountry#</ns:CountryCode>
							<ns:Residential>#iif(arguments.shipperIsResidential, DE('true'), DE('false'))#</ns:Residential>
						</ns:Address>
					</ns:Shipper>
				
					<ns:Recipient>
						<ns:Contact>
							<ns:PersonName>#XMLFormat(arguments.shipToName)#</ns:PersonName>
							<cfif len(trim(arguments.shipToCompany))>
							<ns:CompanyName>#XMLFormat(arguments.shipToCompany)#</ns:CompanyName>
							</cfif>
							<cfif len(trim(arguments.shipToPhone))>
							<ns:PhoneNumber>#XMLFormat(arguments.shipToPhone)#</ns:PhoneNumber>
							</cfif>
							<cfif len(trim(arguments.shipToEmail))>
							<ns:EMailAddress>#XMLFormat(arguments.shipToEmail)#</ns:EMailAddress>
							</cfif>
						</ns:Contact>
						<ns:Address>
							<ns:StreetLines>#XMLFormat(arguments.shipToAddress1)#</ns:StreetLines>
							<cfif len(trim(arguments.shipToAddress2))><ns:StreetLines>#XMLFormat(arguments.shipToAddress2)#</ns:StreetLines></cfif>
							<ns:City>#XMLFormat(arguments.shipToCity)#</ns:City>
							<ns:StateOrProvinceCode>#XMLFormat(arguments.shipToState)#</ns:StateOrProvinceCode>
							<ns:PostalCode>#XMLFormat(arguments.shipToZip)#</ns:PostalCode>
							<ns:CountryCode>#XMLFormat(arguments.shipToCountry)#</ns:CountryCode>
							<ns:Residential>#iif(arguments.shipToResidential, DE('true'), DE('false'))#</ns:Residential>
						</ns:Address>
					</ns:Recipient>

					<ns:ShippingChargesPayment>
						<ns:PaymentType>#arguments.paymentType#</ns:PaymentType>
						<ns:Payor>
							<ns:AccountNumber>#arguments.billingAct#</ns:AccountNumber>
							<ns:CountryCode>#arguments.billingCountry#</ns:CountryCode>
						</ns:Payor>
					</ns:ShippingChargesPayment>

					<cfif len(arguments.specialServices) and listfind("SATURDAY_DELIVERY,SATURDAY_PICKUP,HOLD_AT_LOCATION",arguments.specialServices)>
					<ns:SpecialServicesRequested>
						<ns:SpecialServiceTypes>#arguments.specialServices#</ns:SpecialServiceTypes>    
						<cfswitch expression="#arguments.specialServices#">
						<cfcase value="HOLD_AT_LOCATION">
						<ns:HoldAtLocationDetail>
							<ns:PhoneNumber>#XMLFormat(arguments.holdAtPhone)#</ns:PhoneNumber>
							<ns:Address>
								<ns:StreetLines>#XMLFormat(arguments.holdAtAddress1)#</ns:StreetLines>
								<cfif len(trim(arguments.holdAtAddress2))><ns:StreetLines>#XMLFormat(arguments.holdAtAddress2)#</ns:StreetLines></cfif>
								<ns:City>#XMLFormat(arguments.holdAtCity)#</ns:City>
								<ns:StateOrProvinceCode>#XMLFormat(arguments.hHoldAtState)#</ns:StateOrProvinceCode>
								<ns:PostalCode>#XMLFormat(arguments.holdAtZIP)#</ns:PostalCode>
								<ns:CountryCode>US</ns:CountryCode>
								<ns:Residential>#arguments.holdAtIsResident#</ns:Residential>
							</ns:Address>
						</ns:HoldAtLocationDetail>
						</cfcase>
						</cfswitch>
					</ns:SpecialServicesRequested>
					</cfif>
				
					<ns:LabelSpecification>
						<ns:LabelFormatType>COMMON2D</ns:LabelFormatType>
						<ns:ImageType>#ucase(arguments.imageType)#</ns:ImageType>
						<ns:LabelStockType>#arguments.labelStockType#</ns:LabelStockType>
					</ns:LabelSpecification>
					<ns:RateRequestTypes>ACCOUNT</ns:RateRequestTypes>
					<ns:PackageCount>#listLen(arguments.weight)#</ns:PackageCount>
					<cfloop list="#arguments.weight#" index="i">
						<ns:RequestedPackageLineItems>
							<ns:SequenceNumber>#counter#</ns:SequenceNumber>
							<ns:GroupPackageCount>1</ns:GroupPackageCount>
							<ns:Weight>
								<ns:Units>LB</ns:Units>
								<ns:Value>#trim(arguments.weight)#</ns:Value>
							</ns:Weight>
							<ns:Dimensions>
								<ns:Length>#trim(arguments.length)#</ns:Length>
								<ns:Width>#trim(arguments.width)#</ns:Width>
								<ns:Height>#trim(arguments.height)#</ns:Height>
								<ns:Units>IN</ns:Units>
							</ns:Dimensions>
							<ns:PhysicalPackaging>BOX</ns:PhysicalPackaging>

							<ns:CustomerReferences>
								<ns:CustomerReferenceType>INVOICE_NUMBER</ns:CustomerReferenceType>
								<ns:Value>#arguments.orderid#</ns:Value>
							</ns:CustomerReferences>
							<cfif len(arguments.department)>
							<ns:CustomerReferences>
								<ns:CustomerReferenceType>DEPARTMENT_NUMBER</ns:CustomerReferenceType>
								<ns:Value>#arguments.department#</ns:Value>
							</ns:CustomerReferences>
							</cfif>
							<cfif len(arguments.ponumber)>
							<ns:CustomerReferences>
								<ns:CustomerReferenceType>P_O_NUMBER</ns:CustomerReferenceType>
								<ns:Value>#arguments.ponumber#</ns:Value>
							</ns:CustomerReferences>
							</cfif>

							<cfif len(arguments.specialServices) and listfind("DRY_ICE,DANGEROUS_GOODS",arguments.specialServices)>
							<ns:SpecialServicesRequested>
								<ns:SpecialServiceTypes>#arguments.specialServices#</ns:SpecialServiceTypes>    
								<cfswitch expression="#arguments.specialServices#">
								<cfcase value="DRY_ICE">
								<ns:DryIceWeight>
									<ns:Units>KG</ns:Units>
									<ns:Value>#arguments.dryIceWeight#</ns:Value>
								</ns:DryIceWeight>
								</cfcase>
								<!--- More special services discussions needed to be added here ---->     
								</cfswitch>
							</ns:SpecialServicesRequested>
							</cfif>
						</ns:RequestedPackageLineItems>
						<cfset counter = counter + 1>
					</cfloop>
				</ns:RequestedShipment> 
			</ns:ProcessShipmentRequest>
		</SOAP-ENV:Body>
		</SOAP-ENV:Envelope>		
		</cfoutput></cfsavecontent>
	
		<cfhttp url="#variables.fedexurl#/ship" port="443" method ="POST"> 
			<cfhttpparam name="name" type="XML" value="#XMLPacket#" /> 
		</cfhttp>
		
		<!--- extract response from envelope body --->
		<cfset xmlFile = XmlParse(CFHTTP.FileContent).Envelope.Body />

		<!---Build the Struct for Return--->
		<cfset fedexReply.response = Arraynew(1) />
		
		<cfif arguments.returnRawResponse>
			<cfset fedexReply.rawResponse = CFHTTP.FileContent />
		</cfif>

		<!---Did you pass bad info or malformed XML?--->
		<cfif not isDefined('xmlFile.Fault')>
			
			<cfif xmlfile.ProcessShipmentReply.HighestSeverity.xmltext contains "Error"
				OR xmlfile.ProcessShipmentReply.HighestSeverity.xmltext contains "Warning"
				OR xmlfile.ProcessShipmentReply.HighestSeverity.xmltext contains "Failure">
				
				<cfset err = true />
			</cfif>

			<cfloop from="1" to="#arrayLen(xmlfile.ProcessShipmentReply.Notifications)#" index="n">
				<cfset fedexReply.response[n] = structNew() />
				<cfset fedexReply.response[n].status = xmlfile.ProcessShipmentReply.Notifications[n].Severity.xmltext />
				<cfset fedexReply.response[n].msg = xmlfile.ProcessShipmentReply.Notifications[n].Message.xmltext />
			</cfloop>

			<!---Did FedEx reply with an error?--->
			<cfif NOT err>
				<!---- Save Label / Get Tracking Number --->
				<cfif IsDefined("xmlfile.ProcessShipmentReply.CompletedShipmentDetail.CompletedPackageDetails.TrackingIds.TrackingNumber")>
					<cfset fedexReply.trackingNumber  = xmlfile.ProcessShipmentReply.CompletedShipmentDetail.CompletedPackageDetails.TrackingIds.TrackingNumber.XmlText>

					<cfif len(arguments.labelDirectory) and DirectoryExists(arguments.labelDirectory)>
						<cfset fedexLabel = xmlfile.ProcessShipmentReply.CompletedShipmentDetail.CompletedPackageDetails.Label.Parts.Image.XmlText />
						<cfset fedexLabel = ToBinary(xmlfile.ProcessShipmentReply.CompletedShipmentDetail.CompletedPackageDetails.Label.Parts.Image.XmlText) />
						
						<cfif len(arguments.labelFileName)>
							<cfset fileName = arguments.labelDirectory & arguments.labelFileName & "." & arguments.imageType />
						<cfelse>
							<cfset fileName = arguments.labelDirectory & fedexReply.trackingNumber & "." & arguments.imageType />
						</cfif>

						<cfif FileExists("#fileName#")>
							<cffile action="delete" file="#fileName#" />
						</cfif>
						<cffile action="write" charset="UTF-8" file="#fileName#" output="#fedexLabel#" />
					</cfif>
				<cfelse>
					<cfset fedexReply.trackingNumber = "" />
				</cfif>
			</cfif>
		<cfelse>
			<cfset fedexReply.response = ArrayNew(1) />
			<cfset fedexReply.response[1] = structNew() />
			<cfset fedexReply.response[1].status = "Error" />
			<cfset fedexReply.response[1].msg = xmlFile.Fault.faultstring.xmltext />
				
			<cfset err = true />
		</cfif>
	
		<cfset fedexReply.success = NOT err />

		<cfreturn fedexReply />
	</cffunction>
</cfcomponent>