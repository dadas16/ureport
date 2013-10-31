#!/usr/bin/python
# -*- coding: utf-8 -*-
from django.shortcuts import render_to_response, get_object_or_404, redirect
from django.template import RequestContext
from script.models import ScriptStep
from django.contrib.auth.decorators import login_required
from generic.views import generic
from django.views.decorators.cache import cache_control, never_cache
from django.core.urlresolvers import reverse
from django.http import HttpResponse
from rapidsms_xforms.models import XFormField, XForm
from ureport.models.utils import recent_message_stats
from ussd.models import StubScreen
from poll.models import Poll, Category, Rule, Translation, Response
from poll.forms import CategoryForm, RuleForm2
from rapidsms.models import Contact
from ureport.forms import NewPollForm, GroupsFilter
from django.conf import settings
from ureport.forms import AssignToPollForm, SearchResponsesForm, AssignResponseGroupForm, ReplyTextForm, DeleteSelectedForm
from django.contrib.sites.models import Site, get_current_site
from ureport import tasks
from ureport.utils import get_polls, get_script_polls, get_access
from generic.sorters import SimpleSorter
from ureport.views.utils.paginator import ureport_paginate
from django.db import transaction
from django.contrib.auth.models import Group, User #, Message
from ureport.models import UPoll
import logging, datetime


def view_scouts_responses(req, pol):


    responses= Response.objects.filter(contact__groups__name='scout',poll__pk=pol)
    members= Contact.objects.count()
    p= Poll.objects.get(pk=pol)
    template = 'ureport/scout_poll_result.html'
    return render_to_response(template, {
        'responses': responses,
        'total_ureporters':members,
        'poll':p}
        )

   
def view_guides_responses(req, pol):

    responses= Response.objects.filter(contact__groups__name='guide',poll__pk=pol)
    members= Contact.objects.count()
    p= Poll.objects.get(pk=pol)
    template = 'ureport/guide_poll_result.html'
    return render_to_response(template, {
        'responses': responses,
        'total_members':members,
        'poll':p}
        )
        
def view_redcross_responses(req, pol):

    responses= Response.objects.filter(contact__groups__name='redcross',poll__pk=pol)
    members= Contact.objects.count()
    p= Poll.objects.get(pk=pol)
    template = 'ureport/redcross_poll_result.html'
    return render_to_response(template, {
        'responses': responses,
        'total_members':members,
        'poll':p}
        )
