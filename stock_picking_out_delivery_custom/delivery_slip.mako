## -*- coding: utf-8 -*-
<html>

<!-- We should share the css between all report copy paste ccs from invoice-->
<head>
    <style type="text/css">
        ${css}

        .list_main_table {
            border:thin solid #E3E4EA;
            text-align:center;
            border-collapse: collapse;
        }
        .list_main_table th {
            background-color: #EEEEEE;
            border: thin solid #000000;
            text-align:center;
            font-size:12;
            font-weight:bold;
            padding-right:3px;
            padding-left:3px;
        }
        .list_main_table td {
            border-top : thin solid #EEEEEE;
            text-align:left;
            font-size:12;
            padding-right:3px;
            padding-left:3px;
            padding-top:3px;
            padding-bottom:3px;
        }
        .list_main_table thead {
            display:table-header-group;
        }
        .table_barcode {
            float: right;
        }
        .barcode {
            font-size: 55px;
            font-family: "c39hrp24dhtt";
            margin-right: 40px;
        }

        .footer {
            margin-top: 40px;
            page-break-inside: avoid;
        }


    </style>
</head>

<body>
    <%page expression_filter="entity"/>
    <%
    def carriage_returns(text):
        return text.replace('\n', '<br />')
    %>
    %for picking in objects:
        <div>
            %if picking.origin[0] == '2':
              <% lang = 'en_US' %>
            %else:
              <% lang = 'fr_FR' %>
            %endif
            <% setLang(lang) %>
            <div class="address">
                <table class="recipient">
                    <tr><td class="address_title">${_("Delivery address:")}</td></tr>
                    %if picking.partner_id.parent_id:
                    <tr><td class="name">${picking.partner_id.name or ''}</td></tr>
                    <tr><td>${picking.partner_id.company or ''}</td></tr>
                    <% address_lines = picking.partner_id.contact_address.split("\n")[1:] %>
                    %else:
                    <tr><td>${picking.partner_id.company or ""}</td></tr>
                    <tr><td class="name">${picking.partner_id.title and picking.partner_id.title.name or ''} ${picking.partner_id.name }</td></tr>
                    <tr><td>${picking.partner_id.company or ''}</td></tr>
                    <% address_lines = picking.partner_id.contact_address.split("\n") %>
                    %endif
                    %for part in address_lines:
                        %if part:
                        <tr><td>${part}</td></tr>
                        %endif
                    %endfor
                    <tr><td>${picking.partner_id.phone or picking.partner_id.mobile or ''}</td></tr>
                    <tr><td>${picking.partner_id.email or ''}</td></tr>
                </table>

                <%
                invoice_addr = invoice_address(picking)
                %>
                <table class="invoice">
                    <tr><td class="address_title">${_("Invoice address:")}</td></tr>
                    %if invoice_addr.contact_address:
                        <% address_lines = invoice_addr.contact_address.split("\n") %>
                        %for part in address_lines:
                            %if part:
                            <tr><td>${part}</td></tr>
                            %endif
                        %endfor
                    %endif
                </table>
            </div>
            %if picking.sale_id:
                <h1 style="clear:both;">${_(u'Sale Order:') } ${picking.sale_id.name}</h1>
            %endif
            %if picking.claim_id:
                <h1 style="clear:both;">${_(u'RMA') } ${picking.sale_id.name}</h1>
            %endif
            <h1 style="clear:both;">${_(u'Delivery Order:') } ${picking.name}</h1>
            
            <table class="basic_table" width="100%">
                <tr>
                    <th style="font-weight:bold;">${_("Scheduled Date")}</th>
                    <th style="font-weight:bold;">${_('Weight')}</th>
                    <th style="font-weight:bold;">${_('Delivery Method')}</th>
                </tr>
                <tr>
                    <td>${formatLang(picking.max_date, date=True)}</td>
                    <td>${picking.weight}</td>
                    <td>${picking.carrier_id and picking.carrier_id.name or ''}</td>
                </tr>
            </table>
        
            <table class="list_main_table" width="100%" style="margin-top: 20px;">
                <thead>
                    <tr>
                        <th>${_("Brand")}</th>
                        <th>${_("Collection")}</th>
                        <th>${_("Model")}</th>
                        <th>${_("Description")}</th>
                        <th class="amount">${_("Quantity")}</th>
                    </tr>
                </thead>
                <tbody>
                %for line in picking.move_lines:
                    %if picking.partial:
                        %if line.partial_qty > 0:
                            <tr>
                                <td>${ line.product_brand_id.name }</td>
                                <td>${ line.product_collection_id.name }</td>
                                <td>${ line.product_code }</td>
                                <td>${ line.name }</td>
                                <td class="amount" >${ int(line.partial_qty) }</td>
                            </tr>
                        %endif
                    %else:
                       <tr>
                           <td>${ line.product_brand_id.name }</td>
                           <td>${ line.product_collection_id.name }</td>
                           <td>${ line.product_code }</td>
                           <td>${ line.name }</td>
                           <td class="amount" >${ int(line.product_qty) }</td>
                       </tr>
                    %endif
                %endfor
            </table>
    </div>
    <div class="footer">
        %if lang == 'fr_FR':
            <p><span>
                <strong>
                Nous vous remercions pour votre commande sur dessus-dessous.fr<br/>
                Nous espérons qu’elle vous donnera entière satisfaction.<br/></strong>
                </span>
                <span>Vous souhaitez nous retourner un article ? Dessus Dessous vous facilite les démarches et vous met à disposition une étiquette de retour (pour la France Métropolitaine).  Vous avez 30 jours pour nous retourner votre colis. Connectez-vous sur votre compte, dans la rubrique "Mes retours",  suivez la procédure indiquée et joignez ce bon de livraison à votre colis retour. En cas d'échange, nous vous invitons simplement à repasser commande sur notre site, une fois la procédure de retour effectuée sur notre site et votre avoir crédité.
                </span>
            </p>
            <p><span>
                Besoin d’aide ? Notre équipe est là pour vous !<br/>
                Contactez-nous par e-mail à l’adresse <a style="color: #00000a;" href="mailto:info@dessus-dessous.fr">info@dessus-dessous.fr</a> ou appelez-nous au 04 67 71 58 60.<br/>
                A bientôt sur www.dessus-dessous.fr</span></p>
            <br/>
        %else:
            <p><span>
                <strong>
                Thank you for your order on dessus-dessous.com<br/>
                We hope that you will be satisfied.<br/></strong>
                </span>
                <span>You wish to return an item? In order to facilitate the proceedings, Dessus Dessous provides you with a prepaid return label to stick on your package (for Mainland France only). You have up to 30 days in order to return your parcel. Log into your customer account, in &ldquo;My returns&rdquo;, follow the instructions and join this return form to your parcel. In case of an exchange, we invite you to directly place a new order on our website, once the return is registered and the voucher has been credited to your customer account.<br/>
                </span>
            </p>
            <p><span>
                Need help? Our team is here for you!<br/>
                Contact us by e-mail at <a style="color: #00000a;" href="mailto:info@dessus-dessous.fr">info@dessus-dessous.fr</a> or call us at (+33) 4 67 71 58 60.<br/>
            See you soon on www.dessus-dessous.com</span></p>
            <br/>
        %endif
    </div>
</div>
    %endfor
</body>
</html>
