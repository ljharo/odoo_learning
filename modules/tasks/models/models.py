from odoo import models, fields

class TareaPersonalizada(models.Model):
    _name = 'tasks.tarea'  # Nombre técnico del modelo (en formato 'nombre_modulo.modelo')
    _description = 'Tarea Personalizada'

    name = fields.Char(string='Nombre', required=True)
    descripcion = fields.Text(string='Descripción')
    fecha_inicio = fields.Date(string='Fecha de Inicio')
    fecha_fin = fields.Date(string='Fecha de Fin')
    completada = fields.Boolean(string='Completada')
