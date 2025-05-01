# -*- coding: utf-8 -*-
{
    'name': "tasks manager",
    'summary': "Módulo para gestionar tareas personalizadas",
    'description': "Permite crear y gestionar tareas adicionales.",
    'author': "ljharo",
    'website': "https://www.yourcompany.com",
    'category': 'Uncategorized',
    'version': '0.1',
    'depends': ['base'],
    'data': [
        'security/ir.model.access.csv',
        'views/tarea_views.xml',
    ],
    'installable': True,
    'application': True,
}