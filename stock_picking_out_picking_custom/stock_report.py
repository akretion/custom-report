# -*- coding: utf-8 -*-
###############################################################################
#
#   Module for OpenERP
#   Copyright (C) 2014 Akretion (http://www.akretion.com).
#   @author Sébastien BEAU <sebastien.beau@akretion.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as
#   published by the Free Software Foundation, either version 3 of the
#   License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
###############################################################################

from report import report_sxw
import pooler
import time


class Picking(report_sxw.rml_parse):

    def _get_invoice_address(self, picking):
        if picking.sale_id:
            return picking.sale_id.partner_invoice_id
        partner_obj = self.pool.get('res.partner')
        invoice_address_id = picking.partner_id.address_get(
            adr_pref=['invoice']
        )['invoice']
        return partner_obj.browse(
            self.cr, self.uid, invoice_address_id)

    def _get_selection_value(self, model, field_name, field_val):
        return dict(self.pool.get(model).fields_get(
            self.cr, self.uid)[field_name]['selection'])[field_val]

    def _get_total_qty(self, picking):
        qty = 0
        for line in picking.move_lines:
            qty += line.product_qty
        return int(qty)

    def __init__(self, cr, uid, name, context):
        super(Picking, self).__init__(cr, uid, name, context=context)
        self.localcontext.update({
            'time': time,
            'invoice_address': self._get_invoice_address,
            'get_selection_value': self._get_selection_value,
            'get_total_qty': self._get_total_qty,
        })


report_sxw.report_sxw('report.webkit.picking',
                      'stock.picking',
                      'addons/stock_picking_out_picking_custom/picking.mako',
                      parser=Picking)
