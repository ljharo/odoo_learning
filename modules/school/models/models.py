from odoo import models, fields

class Student(models.Model):
    
    _name = "school.student"
    _description = "tabla de estudiantes"
    
    name = fields.Char(string='numbre', required=True)
    age = fields.Integer(string='edad', required=True)
