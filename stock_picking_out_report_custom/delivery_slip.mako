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

    </style>
</head>

<body>
    <%page expression_filter="entity"/>
    <%
    def carriage_returns(text):
        return text.replace('\n', '<br />')
    %>
    %for picking in objects:
        <% setLang(picking.partner_id.lang) %>
        <% picking.set_printed() %>
        <div class="address">
            <table class="recipient">
                %if picking.partner_id.parent_id:
                <tr><td class="address_title">${_("Delivery address:")}</td></tr>
                <tr><td class="name">${picking.partner_id.parent_id.name or ''}</td></tr>
                <tr><td>${picking.partner_id.title and picking.partner_id.title.name or ''} ${picking.partner_id.name }</td></tr>
                <% address_lines = picking.partner_id.contact_address.split("\n")[1:] %>
                %else:
                <tr><td class="name">${picking.partner_id.title and picking.partner_id.title.name or ''} ${picking.partner_id.name }</td></tr>
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

            <table class="table_barcode">
                <tr>
                    <td>
                        <p class="barcode">
                          *${picking.name}*
                        </p>
                    </td>
                </tr>
            </table>

            <%
            invoice_addr = invoice_address(picking)
            %>
            <table class="invoice">
                <tr><td class="address_title">${_("Invoice address:")}</td></tr>
                <tr><td>${invoice_addr.title and invoice_addr.title.name or ''} ${invoice_addr.name }</td></tr>
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
                    <th>${_("Building")}</th>
                    <th>${_("Brand")}</th>
                    <th>${_("Collection")}</th>
                    <th>${_("Model")}</th>
                    <th>${_("Description")}</th>
                    <th class="amount">${_("Quantity")}</th>
                </tr>
            </thead>
            <tbody>
            %for line in picking.move_lines:
                <tr>
                    <td>${ line.building }</td>
                    <td>${ line.product_brand_id.name }</td>
                    <td>${ line.product_collection_id.name }</td>
                    <td>${ line.product_code }</td>
                    <td>${ line.name }</td>
                    <td class="amount" >${ int(line.product_qty) }</td>
                </tr>
            %endfor
        </table>
        
        <br/>
        %if picking.note :
            <p class="std_text">${picking.note | carriage_returns}</p>
        %endif

        <p style="page-break-after: always"/>
        <br/>
    %endfor
</body>
</html>
