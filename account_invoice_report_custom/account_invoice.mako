## -*- coding: utf-8 -*-
<html>
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

div.formatted_note {
    text-align:left;
    padding-left:10px;
    font-size:11;
}


.list_bank_table {
    text-align:center;
    border-collapse: collapse;
    page-break-inside: avoid;
    display:table;
}

.act_as_row {
   display:table-row;
}
.list_bank_table .act_as_thead {
    background-color: #EEEEEE;
    text-align:left;
    font-size:12;
    font-weight:bold;
    padding-right:3px;
    padding-left:3px;
    white-space:nowrap;
    background-clip:border-box;
    display:table-cell;
}
.list_bank_table .act_as_cell {
    text-align:left;
    font-size:12;
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:3px;
    white-space:nowrap;
    display:table-cell;
}


.list_tax_table {
}
.list_tax_table td {
    text-align:left;
    font-size:12;
}
.list_tax_table th {
}
.list_tax_table thead {
    display:table-header-group;
}


.list_total_table {
    border:thin solid #E3E4EA;
    text-align:center;
    border-collapse: collapse;
}
.list_total_table td {
    border-top : thin solid #EEEEEE;
    text-align:left;
    font-size:12;
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:3px;
}
.list_total_table th {
    background-color: #EEEEEE;
    border: thin solid #000000;
    text-align:center;
    font-size:12;
    font-weight:bold;
    padding-right:3px
    padding-left:3px
}
.list_total_table thead {
    display:table-header-group;
}


.no_bloc {
    border-top: thin solid  #ffffff ;
}

.right_table {
    right: 4cm;
    width:"100%";
}

.std_text {
    font-size:12;
}

tfoot.totals tr:first-child td{
    padding-top: 15px;
}

th.date {
    width: 90px;
}

td.amount, th.amount {
    text-align: right;
    white-space: nowrap;
}
.header_table {
    text-align: center;
    border: 1px solid lightGrey;
    border-collapse: collapse;
}
.header_table th {
    font-size: 12px;
    border: 1px solid lightGrey;
}
.header_table td {
    font-size: 12px;
    border: 1px solid lightGrey;
}

td.date {
    white-space: nowrap;
    width: 90px;
}

td.vat {
    white-space: nowrap;
}
.address .recipient {
    font-size: 12px;
    margin-left: 350px;
    margin-right: 120px;
    float: right;
}

.nobreak {
     page-break-inside: avoid;
 }

.align_top {
     vertical-align:text-top;
 }

    </style>
</head>
<body>
    <%page expression_filter="entity"/>
    <%
    def carriage_returns(text):
        return text.replace('\n', '<br />')
    %>

    <%def name="address(partner, commercial_partner=None)">
        <%doc>
            XXX add a helper for address in report_webkit module as this won't be suported in v8.0
        </%doc>
            <tr><td class="name">${partner.title and partner.title.name or ''} ${partner.name}</td></tr>
            <% address_lines = partner.contact_address.split("\n") %>
        %for part in address_lines:
            % if part:
                <tr><td>${part}</td></tr>
            % endif
        %endfor
    </%def>

    %for inv in objects:
    <% setLang(inv.partner_id.lang) %>
    <div class="address">
      <table class="recipient">
        %if hasattr(inv, 'commercial_partner_id'):
        ${address(partner=inv.partner_id, commercial_partner=inv.commercial_partner_id)}
        %else:
        ${address(partner=inv.partner_id)}
        %endif
      </table>
    </div>
    <h1 style="clear: both; padding-top: 20px;">
        %if inv.type == 'out_invoice' and inv.state == 'proforma2':
            ${_("PRO-FORMA")}
        %elif inv.type == 'out_invoice' and inv.state == 'draft':
            ${_("Draft Invoice")}
        %elif inv.type == 'out_invoice' and inv.state == 'cancel':
            ${_("Cancelled Invoice")} ${inv.number or ''}
        %elif inv.type == 'out_invoice':
            ${_("Invoice")} ${inv.number or ''}
            ${_("Sale Order")} ${inv.origin or ''}
        %elif inv.type == 'in_invoice':
            ${_("Supplier Invoice")} ${inv.number or ''}
        %elif inv.type == 'out_refund':
            ${_("Refund")} ${inv.number or ''}
        %elif inv.type == 'in_refund':
            ${_("Supplier Refund")} ${inv.number or ''}
        %endif
    </h1>

    <table class="basic_table" width="100%">
        <tr>
            <th class="date">${_("Invoice Date")}</td>
            <th style="text-align:center">${_("Payment Term")}</td>
            <th style="text-align:center">${_("Our reference")}</td>
            %if inv.reference and inv.reference != inv.name and inv.origin != inv.reference:
                <th style="text-align:center">${_("Your reference")}</td>
            %endif
        </tr>
        <tr>
            <td class="date">${formatLang(inv.date_invoice, date=True)}</td>
            <td style="text-align:center">${inv.sale_ids and inv.sale_ids[0].payment_method_id.name or ''}</td>
            <td style="text-align:center">${inv.origin or ''}</td>
            %if inv.reference and inv.reference != inv.name and inv.origin != inv.reference:
                <td style="text-align:center">${inv.reference}</td>
            %endif
        </tr>
    </table>

    <div>
    %if inv.note1:
        <p class="std_text"> ${inv.note1 | n} </p>
    %endif
    </div>

    <table class="list_main_table" width="100%" style="margin-top: 20px;">
        <thead>
            <tr>
                <th>${_("Brand")}</th>
                <th>${_("Collection")}</th>
                <th>${_("Model")}</th>
                <th>${_("Description")}</th>
                <th>${_("Qty")}</th>
                <th>${_("UoM")}</th>
                <th>${_("Unit Price")}</th>
                <th>${_("Taxes")}</th>
                <th>${_("Disc.(%)")}</th>
                <th>${_("Sub Total")}</th>
            </tr>
        </thead>
        <tbody>
        %for line in inv.invoice_line :
            <tr>
                <td class="align_top">${line.product_id.categ_brand_id.name or ''}</td>
                <td class="align_top">${line.product_id.collection_id.name or ''}</td>
                <td class="align_top">${line.product_id.base_default_code or ''}</td>
                <td class="align_top"><div class="nobreak">${line.name.replace('\n','<br/>') or '' | n}
                    %if line.formatted_note:
                        <br />
                        <div class="formatted_note">${line.formatted_note| n}</div>
                    %endif
                </div></td>
                <td class="amount align_top">${formatLang(line.quantity or 0.0,digits=get_digits(dp='Account'))}</td>
                <td class="amount align_top">${line.uos_id and line.uos_id.name or ''}</td>
                <td class="amount align_top">${formatLang(line.price_unit)}</td>
                <td class="align_top" style="font-style:italic; font-size: 10;text-align:center;" >${ ', '.join([ tax.description or tax.name for tax in line.invoice_line_tax_id ])}</td>
                <td class="amount align_top" width="10%">${line.discount and formatLang(line.discount, digits=get_digits(dp='Account')) or ''} ${line.discount and '%' or ''}</td>
                <td class="amount align_top" width="13%">${formatLang(line.price_subtotal_taxinc, digits=get_digits(dp='Account'))} ${inv.currency_id.symbol}</td>
            </tr>
        %endfor
        </tbody>
        <tfoot class="totals">
            <tr>
                <td colspan="9" style="text-align:right;border-right: thin solid  #ffffff ;border-left: thin solid  #ffffff ;">
                    <b>${_("Net :")}</b>
                </td>
                <td class="amount" style="border-right: thin solid  #ffffff ;border-left: thin solid  #ffffff ;">
                    ${formatLang(inv.amount_untaxed, digits=get_digits(dp='Account'))} ${inv.currency_id.symbol}
                </td>
            </tr>
            <tr class="no_bloc">
                <td colspan="9" style="text-align:right; border-top: thin solid  #ffffff ; border-right: thin solid  #ffffff ;border-left: thin solid  #ffffff ;">
                    <b>${_("Taxes:")}</b>
                </td>
                <td class="amount" style="border-right: thin solid  #ffffff ;border-top: thin solid  #ffffff ;border-left: thin solid  #ffffff ;">
                        ${formatLang(inv.amount_tax, digits=get_digits(dp='Account'))} ${inv.currency_id.symbol}
                </td>
            </tr>
            <tr>
                <td colspan="9" style="border-right: thin solid  #ffffff ;border-top: thin solid  #ffffff ;border-left: thin solid  #ffffff ;border-bottom: thin solid  #ffffff ;text-align:right;">
                    <b>${_("Total:")}</b>
                </td>
                <td class="amount" style="border-right: thin solid  #ffffff ;border-top: thin solid  #ffffff ;border-left: thin solid  #ffffff ;border-bottom: thin solid  #ffffff ;">
                        <b>${formatLang(inv.amount_total, digits=get_digits(dp='Account'))} ${inv.currency_id.symbol}</b>
                </td>
            </tr>
        </tfoot>
    </table>
        <br/>
    <table class="list_total_table" width="60%" >
        <tr>
            <th style="text-align:left;">${_("Rate")}</th>
            <th>${_("Base")}</th>
            <th>${_("Tax")}</th>
        </tr>
        %if inv.tax_line :
        %for t in inv.tax_line :
            <tr>
                <td style="text-align:left;">${ t.name } </td>
                <td class="amount">${ formatLang(t.base, digits=get_digits(dp='Account')) }</td>
                <td class="amount">${ formatLang(t.amount, digits=get_digits(dp='Account')) }</td>
            </tr>
        %endfor
        %endif
    </table>
        <br/>
        <br/>
    %if inv.note2 :
        <p class="std_text">${inv.note2 | n}</p>
    %endif
    %if inv.fiscal_position and inv.fiscal_position.note:
        <br/>
        <p class="std_text">
        ${inv.fiscal_position.note | n}
        </p>
    %endif

    <p style="page-break-after:always"></p>

    %endfor
</body>
</html>
