## -*- coding: utf-8 -*-
<html>

<!-- We should share the css between all report copy paste ccs from invoice-->
<head>
    <style type="text/css">
        ${css}

        h1 {
            text-align:center;
            font-size: 55px;
            line-height:20px;
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
            font-size:14px;
            font-weight:bold;
            padding-right:3px;
            padding-left:3px;
        }
        .list_main_table td {
            border-top : thin solid #EEEEEE;
            text-align:center;
            font-size:14px;
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
        %if picking.sale_id:
            <h1>${picking.sale_id.name} ${' - '} ${picking.sale_id.date_order}</h1>
        %endif
        %if picking.claim_id:
            <h1>RMA ${picking.sale_id.name}</h1>
        %endif
        <h1>Bon de préparation</h1>
        %if picking.sale_id and picking.sale_id.parent_id:
            <h1>Modification</h1>
        %endif
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
        %if picking.sale_id and not picking.sale_id.paid and picking.sale_id.payment_method_id.code in ['CHQ', 'VIR']:
            <h2 style="clear:both;">PAIEMENT EN ATTENTE</h2>
        %endif
        <h2 style="clear:both;">Livraison :  ${picking.name}</h2>

        <table class="basic_table" width="100%">
            <tr>
                <th style="font-weight:bold;">Date prévue</th>
                <th style="font-weight:bold;">Poids</th>
                <th style="font-weight:bold;">Transporteur</th>
                <th style="font-weight:bold;">Nb commande</th>
                <th style="font-weight:bold;">Total Facturé</th>
            </tr>
            <tr>
                <td>${formatLang(picking.max_date, date=True)}</td>
                <td>${picking.weight}</td>
                <td>${picking.carrier_id and picking.carrier_id.name or ''}</td>
                <td>${picking.sale_id and picking.sale_id.partner_order_number or ''}</td>
                <td>${picking.sale_id and picking.sale_id.partner_order_amount or ''}</td>
            </tr>
        </table>
    
        <table class="list_main_table" width="100%" style="margin-top: 20px;">
            <thead>
                <tr>
                    <th>Qté Stock</th>
                    <th>Qté Réassort</th>
                    <th>Modèle</th>
                    <th>Marque</th>
                    <th>Collection</th>
                    <th>Taille</th>
                    <th>Couleur</th>
                    <th>Type Réassort</th>
                    <th>Stock Restant</th>
                    <th>Nom</th>
                    <th>Batiment</th>
                </tr>
            </thead>
            <tbody>
            %for line in picking.move_lines:
                <%
                    restocking_type = get_selection_value('product.product', 'restocking_type', line.product_id.restocking_type)
                %>
                <tr>
                    <td class="amount">${ line.state == 'assigned' and int(line.product_qty) or ''}</td>
                    <td class="amount">${ line.state != 'assigned' and int(line.product_qty) or ''}</td>
                    <td style="font-weight:bold;">${ line.product_code }</td>
                    <td>${ line.product_brand_id.name }</td>
                    <td>${ line.product_collection_id.name }</td>
                    <td>${ line.product_size }</td>
                    <td>${ line.product_color }</td>
                    <td>${ restocking_type }</td>
                    <td>${ int(line.product_id.immediately_usable_qty) }</td>
                    <td>${ line.product_id.name }</td>
                    <td>${ line.building }</td>
                </tr>
            %endfor
            </tbody>
            <tfoot class="totals">
                <tr>
                    <td colspan="9" style="border-right: thin solid  #ffffff ;border-top: thin solid  #ffffff ;border-left: thin solid  #ffffff ;border-bottom: thin solid  #ffffff ;text-align:right;">
                        <b>${_("Total:")}</b>
                    </td>
                    <td class="amount" style="border-right: thin solid  #ffffff ;border-top: thin solid  #ffffff ;border-left: thin solid  #ffffff ;border-bottom: thin solid  #ffffff ;">
                            <b>${formatLang(picking.sale_id.amount_total_company_currency, digits=get_digits(dp='Account'))} ${picking.sale_id.company_currency_id.symbol}</b>
                    </td>
                </tr>
            </tfoot>
        </table>

        %if picking.note :
            <p class="std_text">${picking.note | carriage_returns}</p>
        %endif

        <p style="page-break-after: always"/>
        <br/>
    %endfor
</body>
</html>
