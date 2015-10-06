## -*- coding: utf-8 -*-
<html>

<!-- We should share the css between all report copy paste ccs from invoice-->
<head>
    <style type="text/css">
        ${css}

        h1 {
            text-align:center;
            font-size: 55px;
        }

        body {
            font-family: helvetica;
            font-size: 11px;
        }

        table {
            font-family: helvetica;
            font-size: 11px;
        }

        .basic_table{
            text-align: center;
            border: 1px solid lightGrey;
            border-collapse: collapse;
        }

        .basic_table td {
            border: 1px solid lightGrey;
            font-size: 12px;
        }

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
            text-align:center;
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

        .address table {
            font-size: 11px;
            border-collapse: collapse;
            margin: 0px;
            padding: 0px;
        }

        .address .shipping {

        }

        .address .invoice {
            margin-top: 10px;
        }

        .address .recipient {
            margin-right: 120px;
            float: right;
        }

        table .address_title {
            font-weight: bold;
        }

        .address td.name {
            font-weight: bold;
        }

        tr.line .note {
            border-style: none;
            font-size: 9px;
            padding-left: 10px;
        }

        tr.line {
            margin-bottom: 10px;
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
        <% setLang('fr_FR') %>
        <% picking.set_printed() %>
        <h1>Bon de préparation</h1>
        <div class="address">
            <table class="recipient">
                <tr><td class="address_title">Adresse de Livraison : </td></tr>
                %if picking.partner_id.parent_id:
                <tr><td class="name">${picking.partner_id.parent_id.name or ''}</td></tr>
                <tr><td>${picking.partner_id.company}</td></tr>
                <% address_lines = picking.partner_id.contact_address.split("\n")[1:] %>
                %else:
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
                <tr><td class="address_title">Adresse de Facturation : </td></tr>
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
            <h2 style="clear:both;">Commande : ${picking.sale_id.name}</h2>
        %endif
        %if picking.claim_id:
            <h2 style="clear:both;">RMA ${picking.sale_id.name}</h2>
        %endif
        <h2 style="clear:both;">Livraison :  ${picking.name}</h2>
        
        <table class="basic_table" width="100%">
            <tr>
                <th style="font-weight:bold;">Date prévue</th>
                <th style="font-weight:bold;">Poids</th>
                <th style="font-weight:bold;">Transporteur</th>
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
                    <th>Batiment</th>
                    <th>Marque</th>
                    <th>Collection</th>
                    <th>Modèle</th>
                    <th>Nom</th>
                    <th>Taille</th>
                    <th>Couleur</th>
                    <th>Qté Stock</th>
                    <th>Qté Réassort</th>
                </tr>
            </thead>
            <tbody>
            %for line in picking.move_lines:
                <tr>
                    <td>${ line.building }</td>
                    <td>${ line.product_brand_id.name }</td>
                    <td>${ line.product_collection_id.name }</td>
                    <td>${ line.product_code }</td>
                    <td>${ line.product_id.name }</td>
                    <td>${ line.product_size }</td>
                    <td>${ line.product_color }</td>
                    <td class="amount">${ line.state == 'assigned' and int(line.product_qty) or ''}</td>
                    <td class="amount">${ line.state != 'assigned' and int(line.product_qty) or ''}</td>
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
