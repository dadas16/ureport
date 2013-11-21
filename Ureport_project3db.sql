--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: contact_update(); Type: FUNCTION; Schema: public; Owner: helpdeskadmin
--

CREATE FUNCTION contact_update() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ 
BEGIN
    PERFORM ureport_contact_refresh_row(new.id);
    RETURN null;
END $$;


ALTER FUNCTION public.contact_update() OWNER TO helpdeskadmin;

--
-- Name: contact_update_message(); Type: FUNCTION; Schema: public; Owner: helpdeskadmin
--

CREATE FUNCTION contact_update_message() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ 
BEGIN
    PERFORM ureport_contact_refresh_row_connection(new.connection_id);
    RETURN null;
END $$;


ALTER FUNCTION public.contact_update_message() OWNER TO helpdeskadmin;

--
-- Name: ureport_contact_refresh_row(integer); Type: FUNCTION; Schema: public; Owner: helpdeskadmin
--

CREATE FUNCTION ureport_contact_refresh_row(rapidsms_contact_id integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ begin
DELETE
FROM ureport_contact uc
WHERE uc.id = rapidsms_contact_id;
INSERT INTO ureport_contact  
SELECT id,
    name,
    is_caregiver,
    reporting_location_id,
    user_id,
    mobile,
    language,
    province,
    age,
    gender,
    facility,
    colline,
    responses,
    questions,
    incoming,
    connection_pk,
    ce.group FROM contacts_export ce WHERE ce.id = rapidsms_contact_id;
end $$;


ALTER FUNCTION public.ureport_contact_refresh_row(rapidsms_contact_id integer) OWNER TO helpdeskadmin;

--
-- Name: ureport_contact_refresh_row_connection(integer); Type: FUNCTION; Schema: public; Owner: helpdeskadmin
--

CREATE FUNCTION ureport_contact_refresh_row_connection(rapidsms_connection_id integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ begin
DELETE
FROM ureport_contact uc
WHERE uc.connection_pk = rapidsms_connection_id;
INSERT INTO ureport_contact  SELECT id,
    name,
    is_caregiver,
    reporting_location_id,
    user_id,
    mobile,
    language,
    province,
    age,
    gender,
    facility,
    colline,
    responses,
    questions,
    incoming,
    connection_pk,
    ce.group  
    FROM contacts_export ce WHERE ce.connection_pk = rapidsms_connection_id;
end $$;


ALTER FUNCTION public.ureport_contact_refresh_row_connection(rapidsms_connection_id integer) OWNER TO helpdeskadmin;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alerts_export; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE alerts_export (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    district character varying(100) NOT NULL,
    message text NOT NULL,
    direction character varying(1) NOT NULL,
    date timestamp with time zone NOT NULL,
    mobile character varying(100) NOT NULL,
    rating character varying(500) NOT NULL,
    replied character varying(50) NOT NULL,
    forwarded character varying(50) NOT NULL
);


ALTER TABLE public.alerts_export OWNER TO helpdeskadmin;

--
-- Name: alerts_export_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE alerts_export_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alerts_export_id_seq OWNER TO helpdeskadmin;

--
-- Name: alerts_export_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE alerts_export_id_seq OWNED BY alerts_export.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO helpdeskadmin;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO helpdeskadmin;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO helpdeskadmin;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO helpdeskadmin;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO helpdeskadmin;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO helpdeskadmin;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(75) NOT NULL,
    password character varying(128) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    is_superuser boolean NOT NULL,
    last_login timestamp with time zone NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO helpdeskadmin;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO helpdeskadmin;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO helpdeskadmin;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO helpdeskadmin;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO helpdeskadmin;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO helpdeskadmin;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: celery_taskmeta; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE celery_taskmeta (
    id integer NOT NULL,
    task_id character varying(255) NOT NULL,
    status character varying(50) NOT NULL,
    result text,
    date_done timestamp with time zone NOT NULL,
    traceback text,
    hidden boolean NOT NULL,
    meta text
);


ALTER TABLE public.celery_taskmeta OWNER TO helpdeskadmin;

--
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE celery_taskmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.celery_taskmeta_id_seq OWNER TO helpdeskadmin;

--
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE celery_taskmeta_id_seq OWNED BY celery_taskmeta.id;


--
-- Name: celery_tasksetmeta; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE celery_tasksetmeta (
    id integer NOT NULL,
    taskset_id character varying(255) NOT NULL,
    result text NOT NULL,
    date_done timestamp with time zone NOT NULL,
    hidden boolean NOT NULL
);


ALTER TABLE public.celery_tasksetmeta OWNER TO helpdeskadmin;

--
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE celery_tasksetmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.celery_tasksetmeta_id_seq OWNER TO helpdeskadmin;

--
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE celery_tasksetmeta_id_seq OWNED BY celery_tasksetmeta.id;


--
-- Name: contact_flag; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE contact_flag (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    words character varying(500),
    rule integer,
    rule_regex character varying(700)
);


ALTER TABLE public.contact_flag OWNER TO helpdeskadmin;

--
-- Name: contact_flag_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE contact_flag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_flag_id_seq OWNER TO helpdeskadmin;

--
-- Name: contact_flag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE contact_flag_id_seq OWNED BY contact_flag.id;


--
-- Name: contact_masstext; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE contact_masstext (
    id integer NOT NULL,
    user_id integer NOT NULL,
    date timestamp with time zone,
    text text NOT NULL
);


ALTER TABLE public.contact_masstext OWNER TO helpdeskadmin;

--
-- Name: contact_masstext_contacts; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE contact_masstext_contacts (
    id integer NOT NULL,
    masstext_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE public.contact_masstext_contacts OWNER TO helpdeskadmin;

--
-- Name: contact_masstext_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE contact_masstext_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_masstext_contacts_id_seq OWNER TO helpdeskadmin;

--
-- Name: contact_masstext_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE contact_masstext_contacts_id_seq OWNED BY contact_masstext_contacts.id;


--
-- Name: contact_masstext_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE contact_masstext_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_masstext_id_seq OWNER TO helpdeskadmin;

--
-- Name: contact_masstext_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE contact_masstext_id_seq OWNED BY contact_masstext.id;


--
-- Name: contact_masstext_sites; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE contact_masstext_sites (
    id integer NOT NULL,
    masstext_id integer NOT NULL,
    site_id integer NOT NULL
);


ALTER TABLE public.contact_masstext_sites OWNER TO helpdeskadmin;

--
-- Name: contact_masstext_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE contact_masstext_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_masstext_sites_id_seq OWNER TO helpdeskadmin;

--
-- Name: contact_masstext_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE contact_masstext_sites_id_seq OWNED BY contact_masstext_sites.id;


--
-- Name: contact_messageflag; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE contact_messageflag (
    id integer NOT NULL,
    message_id integer NOT NULL,
    flag_id integer
);


ALTER TABLE public.contact_messageflag OWNER TO helpdeskadmin;

--
-- Name: contact_messageflag_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE contact_messageflag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_messageflag_id_seq OWNER TO helpdeskadmin;

--
-- Name: contact_messageflag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE contact_messageflag_id_seq OWNED BY contact_messageflag.id;


--
-- Name: locations_location; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE locations_location (
    id integer NOT NULL,
    point_id integer,
    type_id character varying(50),
    parent_type_id integer,
    parent_id integer,
    tree_parent_id integer,
    name character varying(100) NOT NULL,
    status boolean,
    code character varying(100) NOT NULL,
    is_active boolean,
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    CONSTRAINT locations_location_level_check CHECK ((level >= 0)),
    CONSTRAINT locations_location_lft_check CHECK ((lft >= 0)),
    CONSTRAINT locations_location_parent_id_check CHECK ((parent_id >= 0)),
    CONSTRAINT locations_location_rght_check CHECK ((rght >= 0)),
    CONSTRAINT locations_location_tree_id_check CHECK ((tree_id >= 0))
);


ALTER TABLE public.locations_location OWNER TO helpdeskadmin;

--
-- Name: poll_poll_contacts; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE poll_poll_contacts (
    id integer NOT NULL,
    poll_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE public.poll_poll_contacts OWNER TO helpdeskadmin;

--
-- Name: poll_response; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE poll_response (
    id integer NOT NULL,
    message_id integer,
    poll_id integer NOT NULL,
    contact_id integer,
    date timestamp with time zone NOT NULL,
    has_errors boolean NOT NULL
);


ALTER TABLE public.poll_response OWNER TO helpdeskadmin;

--
-- Name: rapidsms_connection; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_connection (
    id integer NOT NULL,
    backend_id integer NOT NULL,
    identity character varying(100) NOT NULL,
    contact_id integer,
    created_on timestamp with time zone,
    modified_on timestamp with time zone
);


ALTER TABLE public.rapidsms_connection OWNER TO helpdeskadmin;

--
-- Name: rapidsms_contact; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_contact (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    language character varying(6) NOT NULL,
    user_id integer,
    reporting_location_id integer,
    health_facility character varying(50),
    is_caregiver boolean NOT NULL,
    occupation character varying(500),
    commune_id integer,
    active boolean NOT NULL,
    birthdate timestamp with time zone,
    gender character varying(1),
    colline_id integer,
    colline_name character varying(100),
    created_on timestamp with time zone,
    modified_on timestamp with time zone
);


ALTER TABLE public.rapidsms_contact OWNER TO helpdeskadmin;

--
-- Name: rapidsms_contact_groups; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_contact_groups (
    id integer NOT NULL,
    contact_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.rapidsms_contact_groups OWNER TO helpdeskadmin;

--
-- Name: rapidsms_httprouter_message; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_httprouter_message (
    id integer NOT NULL,
    connection_id integer NOT NULL,
    text text NOT NULL,
    direction character varying(1) NOT NULL,
    status character varying(1) NOT NULL,
    date timestamp with time zone NOT NULL,
    in_response_to_id integer,
    updated timestamp with time zone,
    sent timestamp with time zone,
    delivered timestamp with time zone,
    batch_id integer,
    priority integer NOT NULL,
    application character varying(100)
);


ALTER TABLE public.rapidsms_httprouter_message OWNER TO helpdeskadmin;

--
-- Name: contacts_export; Type: VIEW; Schema: public; Owner: helpdeskadmin
--

CREATE VIEW contacts_export AS
    SELECT rapidsms_contact.id, rapidsms_contact.name, rapidsms_contact.is_caregiver, rapidsms_contact.reporting_location_id, rapidsms_contact.user_id, (SELECT rapidsms_connection.identity FROM rapidsms_connection WHERE (rapidsms_connection.contact_id = rapidsms_contact.id) LIMIT 1) AS mobile, rapidsms_contact.language, locations_location.name AS province, age(rapidsms_contact.birthdate) AS age, rapidsms_contact.gender, rapidsms_contact.health_facility AS facility, (SELECT locations_location.name FROM locations_location WHERE (locations_location.id = rapidsms_contact.colline_id)) AS colline, (SELECT auth_group.name FROM (auth_group JOIN rapidsms_contact_groups ON ((auth_group.id = rapidsms_contact_groups.group_id))) WHERE (rapidsms_contact_groups.contact_id = rapidsms_contact.id) ORDER BY auth_group.id DESC LIMIT 1) AS "group", (SELECT count(poll_response.id) AS count FROM poll_response WHERE (poll_response.contact_id = rapidsms_contact.id)) AS responses, (SELECT DISTINCT count(poll_poll_contacts.id) AS count FROM poll_poll_contacts WHERE (poll_poll_contacts.contact_id = rapidsms_contact.id) GROUP BY poll_poll_contacts.contact_id) AS questions, (SELECT DISTINCT count(*) AS count FROM rapidsms_httprouter_message WHERE (((rapidsms_httprouter_message.direction)::text = 'I'::text) AND (rapidsms_httprouter_message.connection_id = (SELECT rapidsms_connection.id FROM rapidsms_connection WHERE (rapidsms_connection.contact_id = rapidsms_contact.id) LIMIT 1)))) AS incoming, (SELECT rapidsms_connection.id FROM rapidsms_connection WHERE (rapidsms_connection.contact_id = rapidsms_contact.id) LIMIT 1) AS connection_pk FROM (rapidsms_contact LEFT JOIN locations_location ON ((rapidsms_contact.reporting_location_id = locations_location.id)));


ALTER TABLE public.contacts_export OWNER TO helpdeskadmin;

--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    content_type_id integer,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO helpdeskadmin;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO helpdeskadmin;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO helpdeskadmin;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO helpdeskadmin;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO helpdeskadmin;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO helpdeskadmin;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO helpdeskadmin;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE django_site_id_seq OWNED BY django_site.id;


--
-- Name: djcelery_crontabschedule; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE djcelery_crontabschedule (
    id integer NOT NULL,
    minute character varying(64) NOT NULL,
    hour character varying(64) NOT NULL,
    day_of_week character varying(64) NOT NULL,
    day_of_month character varying(64) NOT NULL,
    month_of_year character varying(64) NOT NULL
);


ALTER TABLE public.djcelery_crontabschedule OWNER TO helpdeskadmin;

--
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE djcelery_crontabschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.djcelery_crontabschedule_id_seq OWNER TO helpdeskadmin;

--
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE djcelery_crontabschedule_id_seq OWNED BY djcelery_crontabschedule.id;


--
-- Name: djcelery_intervalschedule; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE djcelery_intervalschedule (
    id integer NOT NULL,
    every integer NOT NULL,
    period character varying(24) NOT NULL
);


ALTER TABLE public.djcelery_intervalschedule OWNER TO helpdeskadmin;

--
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE djcelery_intervalschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.djcelery_intervalschedule_id_seq OWNER TO helpdeskadmin;

--
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE djcelery_intervalschedule_id_seq OWNED BY djcelery_intervalschedule.id;


--
-- Name: djcelery_periodictask; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE djcelery_periodictask (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    task character varying(200) NOT NULL,
    interval_id integer,
    crontab_id integer,
    args text NOT NULL,
    kwargs text NOT NULL,
    queue character varying(200),
    exchange character varying(200),
    routing_key character varying(200),
    expires timestamp with time zone,
    enabled boolean NOT NULL,
    last_run_at timestamp with time zone,
    total_run_count integer NOT NULL,
    date_changed timestamp with time zone NOT NULL,
    description text NOT NULL,
    CONSTRAINT djcelery_periodictask_total_run_count_check CHECK ((total_run_count >= 0))
);


ALTER TABLE public.djcelery_periodictask OWNER TO helpdeskadmin;

--
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE djcelery_periodictask_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.djcelery_periodictask_id_seq OWNER TO helpdeskadmin;

--
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE djcelery_periodictask_id_seq OWNED BY djcelery_periodictask.id;


--
-- Name: djcelery_periodictasks; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE djcelery_periodictasks (
    ident smallint NOT NULL,
    last_update timestamp with time zone NOT NULL
);


ALTER TABLE public.djcelery_periodictasks OWNER TO helpdeskadmin;

--
-- Name: djcelery_taskstate; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE djcelery_taskstate (
    id integer NOT NULL,
    state character varying(64) NOT NULL,
    task_id character varying(36) NOT NULL,
    name character varying(200),
    tstamp timestamp with time zone NOT NULL,
    args text,
    kwargs text,
    eta timestamp with time zone,
    expires timestamp with time zone,
    result text,
    traceback text,
    runtime double precision,
    retries integer NOT NULL,
    worker_id integer,
    hidden boolean NOT NULL
);


ALTER TABLE public.djcelery_taskstate OWNER TO helpdeskadmin;

--
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE djcelery_taskstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.djcelery_taskstate_id_seq OWNER TO helpdeskadmin;

--
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE djcelery_taskstate_id_seq OWNED BY djcelery_taskstate.id;


--
-- Name: djcelery_workerstate; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE djcelery_workerstate (
    id integer NOT NULL,
    hostname character varying(255) NOT NULL,
    last_heartbeat timestamp with time zone
);


ALTER TABLE public.djcelery_workerstate OWNER TO helpdeskadmin;

--
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE djcelery_workerstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.djcelery_workerstate_id_seq OWNER TO helpdeskadmin;

--
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE djcelery_workerstate_id_seq OWNED BY djcelery_workerstate.id;


--
-- Name: eav_attribute; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE eav_attribute (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    site_id integer NOT NULL,
    slug character varying(50) NOT NULL,
    description character varying(256),
    enum_group_id integer,
    type character varying(20),
    datatype character varying(6) NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    required boolean NOT NULL
);


ALTER TABLE public.eav_attribute OWNER TO helpdeskadmin;

--
-- Name: eav_attribute_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE eav_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eav_attribute_id_seq OWNER TO helpdeskadmin;

--
-- Name: eav_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE eav_attribute_id_seq OWNED BY eav_attribute.id;


--
-- Name: eav_encounter; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE eav_encounter (
    id integer NOT NULL,
    num smallint NOT NULL,
    patient_id integer NOT NULL,
    CONSTRAINT eav_encounter_num_check CHECK ((num >= 0))
);


ALTER TABLE public.eav_encounter OWNER TO helpdeskadmin;

--
-- Name: eav_encounter_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE eav_encounter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eav_encounter_id_seq OWNER TO helpdeskadmin;

--
-- Name: eav_encounter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE eav_encounter_id_seq OWNED BY eav_encounter.id;


--
-- Name: eav_enumgroup; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE eav_enumgroup (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.eav_enumgroup OWNER TO helpdeskadmin;

--
-- Name: eav_enumgroup_enums; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE eav_enumgroup_enums (
    id integer NOT NULL,
    enumgroup_id integer NOT NULL,
    enumvalue_id integer NOT NULL
);


ALTER TABLE public.eav_enumgroup_enums OWNER TO helpdeskadmin;

--
-- Name: eav_enumgroup_enums_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE eav_enumgroup_enums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eav_enumgroup_enums_id_seq OWNER TO helpdeskadmin;

--
-- Name: eav_enumgroup_enums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE eav_enumgroup_enums_id_seq OWNED BY eav_enumgroup_enums.id;


--
-- Name: eav_enumgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE eav_enumgroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eav_enumgroup_id_seq OWNER TO helpdeskadmin;

--
-- Name: eav_enumgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE eav_enumgroup_id_seq OWNED BY eav_enumgroup.id;


--
-- Name: eav_enumvalue; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE eav_enumvalue (
    id integer NOT NULL,
    value character varying(50) NOT NULL
);


ALTER TABLE public.eav_enumvalue OWNER TO helpdeskadmin;

--
-- Name: eav_enumvalue_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE eav_enumvalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eav_enumvalue_id_seq OWNER TO helpdeskadmin;

--
-- Name: eav_enumvalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE eav_enumvalue_id_seq OWNED BY eav_enumvalue.id;


--
-- Name: eav_patient; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE eav_patient (
    id integer NOT NULL,
    name character varying(12) NOT NULL
);


ALTER TABLE public.eav_patient OWNER TO helpdeskadmin;

--
-- Name: eav_patient_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE eav_patient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eav_patient_id_seq OWNER TO helpdeskadmin;

--
-- Name: eav_patient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE eav_patient_id_seq OWNED BY eav_patient.id;


--
-- Name: eav_value; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE eav_value (
    id integer NOT NULL,
    entity_ct_id integer NOT NULL,
    entity_id integer NOT NULL,
    value_text text,
    value_float double precision,
    value_int integer,
    value_date timestamp with time zone,
    value_bool boolean,
    value_enum_id integer,
    generic_value_id integer,
    generic_value_ct_id integer,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    attribute_id integer NOT NULL
);


ALTER TABLE public.eav_value OWNER TO helpdeskadmin;

--
-- Name: eav_value_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE eav_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eav_value_id_seq OWNER TO helpdeskadmin;

--
-- Name: eav_value_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE eav_value_id_seq OWNED BY eav_value.id;


--
-- Name: generic_dashboard; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE generic_dashboard (
    id integer NOT NULL,
    user_id integer,
    slug character varying(50) NOT NULL
);


ALTER TABLE public.generic_dashboard OWNER TO helpdeskadmin;

--
-- Name: generic_dashboard_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE generic_dashboard_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.generic_dashboard_id_seq OWNER TO helpdeskadmin;

--
-- Name: generic_dashboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE generic_dashboard_id_seq OWNED BY generic_dashboard.id;


--
-- Name: generic_module; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE generic_module (
    id integer NOT NULL,
    dashboard_id integer NOT NULL,
    title character varying(40) NOT NULL,
    view_name character varying(30) NOT NULL,
    "offset" integer NOT NULL,
    "column" integer NOT NULL
);


ALTER TABLE public.generic_module OWNER TO helpdeskadmin;

--
-- Name: generic_module_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE generic_module_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.generic_module_id_seq OWNER TO helpdeskadmin;

--
-- Name: generic_module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE generic_module_id_seq OWNED BY generic_module.id;


--
-- Name: generic_moduleparams; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE generic_moduleparams (
    id integer NOT NULL,
    module_id integer NOT NULL,
    param_name character varying(30) NOT NULL,
    param_value character varying(30) NOT NULL,
    is_url_param boolean NOT NULL
);


ALTER TABLE public.generic_moduleparams OWNER TO helpdeskadmin;

--
-- Name: generic_moduleparams_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE generic_moduleparams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.generic_moduleparams_id_seq OWNER TO helpdeskadmin;

--
-- Name: generic_moduleparams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE generic_moduleparams_id_seq OWNED BY generic_moduleparams.id;


--
-- Name: generic_staticmodulecontent; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE generic_staticmodulecontent (
    id integer NOT NULL,
    content text NOT NULL
);


ALTER TABLE public.generic_staticmodulecontent OWNER TO helpdeskadmin;

--
-- Name: generic_staticmodulecontent_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE generic_staticmodulecontent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.generic_staticmodulecontent_id_seq OWNER TO helpdeskadmin;

--
-- Name: generic_staticmodulecontent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE generic_staticmodulecontent_id_seq OWNED BY generic_staticmodulecontent.id;


--
-- Name: geoserver_basicclasslayer; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE geoserver_basicclasslayer (
    id integer NOT NULL,
    district character varying(100),
    style_class character varying(100),
    deployment_id integer NOT NULL,
    layer_id integer NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.geoserver_basicclasslayer OWNER TO helpdeskadmin;

--
-- Name: geoserver_basicclasslayer_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE geoserver_basicclasslayer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geoserver_basicclasslayer_id_seq OWNER TO helpdeskadmin;

--
-- Name: geoserver_basicclasslayer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE geoserver_basicclasslayer_id_seq OWNED BY geoserver_basicclasslayer.id;


--
-- Name: geoserver_emisattendencedata; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE geoserver_emisattendencedata (
    id integer NOT NULL,
    district character varying(100),
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    boys integer NOT NULL,
    girls integer NOT NULL,
    total_pupils integer NOT NULL,
    female_teachers integer NOT NULL,
    male_teachers integer NOT NULL,
    total_teachers integer NOT NULL
);


ALTER TABLE public.geoserver_emisattendencedata OWNER TO helpdeskadmin;

--
-- Name: geoserver_emisattendencedata_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE geoserver_emisattendencedata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geoserver_emisattendencedata_id_seq OWNER TO helpdeskadmin;

--
-- Name: geoserver_emisattendencedata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE geoserver_emisattendencedata_id_seq OWNED BY geoserver_emisattendencedata.id;


--
-- Name: geoserver_pollcategorydata; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE geoserver_pollcategorydata (
    id integer NOT NULL,
    district character varying(100),
    poll_id integer NOT NULL,
    deployment_id integer NOT NULL,
    top_category integer,
    description text NOT NULL
);


ALTER TABLE public.geoserver_pollcategorydata OWNER TO helpdeskadmin;

--
-- Name: geoserver_pollcategorydata_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE geoserver_pollcategorydata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geoserver_pollcategorydata_id_seq OWNER TO helpdeskadmin;

--
-- Name: geoserver_pollcategorydata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE geoserver_pollcategorydata_id_seq OWNED BY geoserver_pollcategorydata.id;


--
-- Name: geoserver_polldata; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE geoserver_polldata (
    id integer NOT NULL,
    district character varying(100),
    poll_id integer NOT NULL,
    deployment_id integer NOT NULL,
    yes double precision,
    no double precision,
    uncategorized double precision,
    unknown double precision
);


ALTER TABLE public.geoserver_polldata OWNER TO helpdeskadmin;

--
-- Name: geoserver_polldata_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE geoserver_polldata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geoserver_polldata_id_seq OWNER TO helpdeskadmin;

--
-- Name: geoserver_polldata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE geoserver_polldata_id_seq OWNED BY geoserver_polldata.id;


--
-- Name: geoserver_pollresponsedata; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE geoserver_pollresponsedata (
    id integer NOT NULL,
    district character varying(100),
    poll_id integer NOT NULL,
    deployment_id integer NOT NULL,
    percentage double precision
);


ALTER TABLE public.geoserver_pollresponsedata OWNER TO helpdeskadmin;

--
-- Name: geoserver_pollresponsedata_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE geoserver_pollresponsedata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geoserver_pollresponsedata_id_seq OWNER TO helpdeskadmin;

--
-- Name: geoserver_pollresponsedata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE geoserver_pollresponsedata_id_seq OWNED BY geoserver_pollresponsedata.id;


--
-- Name: ibm_action; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ibm_action (
    action_id smallint NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.ibm_action OWNER TO helpdeskadmin;

--
-- Name: ibm_category; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ibm_category (
    category_id smallint NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.ibm_category OWNER TO helpdeskadmin;

--
-- Name: ibm_msg_category; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ibm_msg_category (
    msg_id integer NOT NULL,
    category_id smallint NOT NULL,
    score double precision NOT NULL,
    action_id smallint
);


ALTER TABLE public.ibm_msg_category OWNER TO helpdeskadmin;

--
-- Name: locations_location_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE locations_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.locations_location_id_seq OWNER TO helpdeskadmin;

--
-- Name: locations_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE locations_location_id_seq OWNED BY locations_location.id;


--
-- Name: locations_locationtype; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE locations_locationtype (
    name character varying(100) NOT NULL,
    slug character varying(50) NOT NULL
);


ALTER TABLE public.locations_locationtype OWNER TO helpdeskadmin;

--
-- Name: locations_point; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE locations_point (
    id integer NOT NULL,
    latitude numeric(13,10) NOT NULL,
    longitude numeric(13,10) NOT NULL
);


ALTER TABLE public.locations_point OWNER TO helpdeskadmin;

--
-- Name: locations_point_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE locations_point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.locations_point_id_seq OWNER TO helpdeskadmin;

--
-- Name: locations_point_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE locations_point_id_seq OWNED BY locations_point.id;


--
-- Name: messagelog_message; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE messagelog_message (
    id integer NOT NULL,
    contact_id integer,
    connection_id integer,
    direction character varying(1) NOT NULL,
    date timestamp with time zone NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.messagelog_message OWNER TO helpdeskadmin;

--
-- Name: messagelog_message_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE messagelog_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.messagelog_message_id_seq OWNER TO helpdeskadmin;

--
-- Name: messagelog_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE messagelog_message_id_seq OWNED BY messagelog_message.id;


--
-- Name: poll_category; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE poll_category (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    poll_id integer NOT NULL,
    priority smallint,
    color character varying(6) NOT NULL,
    "default" boolean NOT NULL,
    response character varying(160),
    error_category boolean NOT NULL,
    CONSTRAINT poll_category_priority_check CHECK ((priority >= 0))
);


ALTER TABLE public.poll_category OWNER TO helpdeskadmin;

--
-- Name: poll_category_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE poll_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_category_id_seq OWNER TO helpdeskadmin;

--
-- Name: poll_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE poll_category_id_seq OWNED BY poll_category.id;


--
-- Name: poll_poll; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE poll_poll (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    question character varying(160) NOT NULL,
    user_id integer NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    type character varying(8),
    default_response character varying(160),
    response_type character varying(1)
);


ALTER TABLE public.poll_poll OWNER TO helpdeskadmin;

--
-- Name: poll_poll_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE poll_poll_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_poll_contacts_id_seq OWNER TO helpdeskadmin;

--
-- Name: poll_poll_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE poll_poll_contacts_id_seq OWNED BY poll_poll_contacts.id;


--
-- Name: poll_poll_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE poll_poll_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_poll_id_seq OWNER TO helpdeskadmin;

--
-- Name: poll_poll_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE poll_poll_id_seq OWNED BY poll_poll.id;


--
-- Name: poll_poll_messages; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE poll_poll_messages (
    id integer NOT NULL,
    poll_id integer NOT NULL,
    message_id integer NOT NULL
);


ALTER TABLE public.poll_poll_messages OWNER TO helpdeskadmin;

--
-- Name: poll_poll_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE poll_poll_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_poll_messages_id_seq OWNER TO helpdeskadmin;

--
-- Name: poll_poll_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE poll_poll_messages_id_seq OWNED BY poll_poll_messages.id;


--
-- Name: poll_poll_sites; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE poll_poll_sites (
    id integer NOT NULL,
    poll_id integer NOT NULL,
    site_id integer NOT NULL
);


ALTER TABLE public.poll_poll_sites OWNER TO helpdeskadmin;

--
-- Name: poll_poll_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE poll_poll_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_poll_sites_id_seq OWNER TO helpdeskadmin;

--
-- Name: poll_poll_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE poll_poll_sites_id_seq OWNED BY poll_poll_sites.id;


--
-- Name: poll_response_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE poll_response_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_response_id_seq OWNER TO helpdeskadmin;

--
-- Name: poll_response_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE poll_response_id_seq OWNED BY poll_response.id;


--
-- Name: poll_responsecategory; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE poll_responsecategory (
    id integer NOT NULL,
    category_id integer NOT NULL,
    response_id integer NOT NULL,
    is_override boolean NOT NULL,
    user_id integer
);


ALTER TABLE public.poll_responsecategory OWNER TO helpdeskadmin;

--
-- Name: poll_responsecategory_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE poll_responsecategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_responsecategory_id_seq OWNER TO helpdeskadmin;

--
-- Name: poll_responsecategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE poll_responsecategory_id_seq OWNED BY poll_responsecategory.id;


--
-- Name: poll_rule; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE poll_rule (
    id integer NOT NULL,
    regex character varying(256) NOT NULL,
    category_id integer NOT NULL,
    rule_type character varying(2) NOT NULL,
    rule_string character varying(256),
    rule integer
);


ALTER TABLE public.poll_rule OWNER TO helpdeskadmin;

--
-- Name: poll_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE poll_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_rule_id_seq OWNER TO helpdeskadmin;

--
-- Name: poll_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE poll_rule_id_seq OWNED BY poll_rule.id;


--
-- Name: poll_translation; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE poll_translation (
    id integer NOT NULL,
    field text NOT NULL,
    language character varying(5) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.poll_translation OWNER TO helpdeskadmin;

--
-- Name: poll_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE poll_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poll_translation_id_seq OWNER TO helpdeskadmin;

--
-- Name: poll_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE poll_translation_id_seq OWNED BY poll_translation.id;


--
-- Name: rapidsms_app; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_app (
    id integer NOT NULL,
    module character varying(100) NOT NULL,
    active boolean NOT NULL
);


ALTER TABLE public.rapidsms_app OWNER TO helpdeskadmin;

--
-- Name: rapidsms_app_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_app_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_app_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_app_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_app_id_seq OWNED BY rapidsms_app.id;


--
-- Name: rapidsms_backend; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_backend (
    id integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE public.rapidsms_backend OWNER TO helpdeskadmin;

--
-- Name: rapidsms_backend_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_backend_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_backend_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_backend_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_backend_id_seq OWNED BY rapidsms_backend.id;


--
-- Name: rapidsms_connection_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_connection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_connection_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_connection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_connection_id_seq OWNED BY rapidsms_connection.id;


--
-- Name: rapidsms_contact_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_contact_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_contact_groups_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_contact_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_contact_groups_id_seq OWNED BY rapidsms_contact_groups.id;


--
-- Name: rapidsms_contact_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_contact_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_contact_id_seq OWNED BY rapidsms_contact.id;


--
-- Name: rapidsms_contact_user_permissions; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_contact_user_permissions (
    id integer NOT NULL,
    contact_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.rapidsms_contact_user_permissions OWNER TO helpdeskadmin;

--
-- Name: rapidsms_contact_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_contact_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_contact_user_permissions_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_contact_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_contact_user_permissions_id_seq OWNED BY rapidsms_contact_user_permissions.id;


--
-- Name: rapidsms_httprouter_deliveryerror; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_httprouter_deliveryerror (
    id integer NOT NULL,
    message_id integer NOT NULL,
    log text NOT NULL,
    created_on timestamp with time zone NOT NULL
);


ALTER TABLE public.rapidsms_httprouter_deliveryerror OWNER TO helpdeskadmin;

--
-- Name: rapidsms_httprouter_deliveryerror_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_httprouter_deliveryerror_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_httprouter_deliveryerror_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_httprouter_deliveryerror_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_httprouter_deliveryerror_id_seq OWNED BY rapidsms_httprouter_deliveryerror.id;


--
-- Name: rapidsms_httprouter_message_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_httprouter_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_httprouter_message_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_httprouter_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_httprouter_message_id_seq OWNED BY rapidsms_httprouter_message.id;


--
-- Name: rapidsms_httprouter_messagebatch; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_httprouter_messagebatch (
    id integer NOT NULL,
    status character varying(1) NOT NULL,
    name character varying(15)
);


ALTER TABLE public.rapidsms_httprouter_messagebatch OWNER TO helpdeskadmin;

--
-- Name: rapidsms_httprouter_messagebatch_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_httprouter_messagebatch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_httprouter_messagebatch_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_httprouter_messagebatch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_httprouter_messagebatch_id_seq OWNED BY rapidsms_httprouter_messagebatch.id;


--
-- Name: rapidsms_xforms_binaryvalue; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_binaryvalue (
    id integer NOT NULL,
    "binary" character varying(100) NOT NULL
);


ALTER TABLE public.rapidsms_xforms_binaryvalue OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_binaryvalue_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_xforms_binaryvalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_xforms_binaryvalue_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_binaryvalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_xforms_binaryvalue_id_seq OWNED BY rapidsms_xforms_binaryvalue.id;


--
-- Name: rapidsms_xforms_xform; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_xform (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    keyword character varying(32) NOT NULL,
    description text NOT NULL,
    response character varying(255) NOT NULL,
    active boolean NOT NULL,
    command_prefix character varying(1),
    keyword_prefix character varying(1),
    separator character varying(8),
    restrict_message character varying(160),
    owner_id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    site_id integer NOT NULL
);


ALTER TABLE public.rapidsms_xforms_xform OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xform_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_xforms_xform_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_xforms_xform_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xform_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_xforms_xform_id_seq OWNED BY rapidsms_xforms_xform.id;


--
-- Name: rapidsms_xforms_xform_restrict_to; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_xform_restrict_to (
    id integer NOT NULL,
    xform_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.rapidsms_xforms_xform_restrict_to OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xform_restrict_to_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_xforms_xform_restrict_to_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_xforms_xform_restrict_to_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xform_restrict_to_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_xforms_xform_restrict_to_id_seq OWNED BY rapidsms_xforms_xform_restrict_to.id;


--
-- Name: rapidsms_xforms_xformfield; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_xformfield (
    attribute_ptr_id integer NOT NULL,
    xform_id integer NOT NULL,
    field_type character varying(8),
    command character varying(32) NOT NULL,
    "order" integer NOT NULL,
    question text
);


ALTER TABLE public.rapidsms_xforms_xformfield OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformfieldconstraint; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_xformfieldconstraint (
    id integer NOT NULL,
    field_id integer NOT NULL,
    type character varying(10) NOT NULL,
    test character varying(255),
    message character varying(160) NOT NULL,
    "order" integer NOT NULL
);


ALTER TABLE public.rapidsms_xforms_xformfieldconstraint OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformfieldconstraint_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_xforms_xformfieldconstraint_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_xforms_xformfieldconstraint_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformfieldconstraint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_xforms_xformfieldconstraint_id_seq OWNED BY rapidsms_xforms_xformfieldconstraint.id;


--
-- Name: rapidsms_xforms_xformlist; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_xformlist (
    id integer NOT NULL,
    xform_id integer NOT NULL,
    report_id integer NOT NULL,
    required boolean NOT NULL,
    priority integer NOT NULL
);


ALTER TABLE public.rapidsms_xforms_xformlist OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformlist_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_xforms_xformlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_xforms_xformlist_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_xforms_xformlist_id_seq OWNED BY rapidsms_xforms_xformlist.id;


--
-- Name: rapidsms_xforms_xformreport; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_xformreport (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    frequency character varying(32) NOT NULL,
    constraints text NOT NULL
);


ALTER TABLE public.rapidsms_xforms_xformreport OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformreport_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_xforms_xformreport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_xforms_xformreport_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformreport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_xforms_xformreport_id_seq OWNED BY rapidsms_xforms_xformreport.id;


--
-- Name: rapidsms_xforms_xformreportsubmission; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_xformreportsubmission (
    id integer NOT NULL,
    report_id integer NOT NULL,
    start_date timestamp with time zone NOT NULL,
    status character varying(10) NOT NULL,
    created timestamp with time zone NOT NULL
);


ALTER TABLE public.rapidsms_xforms_xformreportsubmission OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformreportsubmission_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_xforms_xformreportsubmission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_xforms_xformreportsubmission_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformreportsubmission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_xforms_xformreportsubmission_id_seq OWNED BY rapidsms_xforms_xformreportsubmission.id;


--
-- Name: rapidsms_xforms_xformreportsubmission_submissions; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_xformreportsubmission_submissions (
    id integer NOT NULL,
    xformreportsubmission_id integer NOT NULL,
    xformsubmission_id integer NOT NULL
);


ALTER TABLE public.rapidsms_xforms_xformreportsubmission_submissions OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformreportsubmission_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_xforms_xformreportsubmission_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_xforms_xformreportsubmission_submissions_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformreportsubmission_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_xforms_xformreportsubmission_submissions_id_seq OWNED BY rapidsms_xforms_xformreportsubmission_submissions.id;


--
-- Name: rapidsms_xforms_xformsubmission; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_xformsubmission (
    id integer NOT NULL,
    xform_id integer NOT NULL,
    type character varying(8) NOT NULL,
    connection_id integer,
    raw text NOT NULL,
    has_errors boolean NOT NULL,
    approved boolean NOT NULL,
    created timestamp with time zone NOT NULL,
    confirmation_id integer NOT NULL,
    message_id integer
);


ALTER TABLE public.rapidsms_xforms_xformsubmission OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformsubmission_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE rapidsms_xforms_xformsubmission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rapidsms_xforms_xformsubmission_id_seq OWNER TO helpdeskadmin;

--
-- Name: rapidsms_xforms_xformsubmission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE rapidsms_xforms_xformsubmission_id_seq OWNED BY rapidsms_xforms_xformsubmission.id;


--
-- Name: rapidsms_xforms_xformsubmissionvalue; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE rapidsms_xforms_xformsubmissionvalue (
    value_ptr_id integer NOT NULL,
    submission_id integer NOT NULL
);


ALTER TABLE public.rapidsms_xforms_xformsubmissionvalue OWNER TO helpdeskadmin;

--
-- Name: script_email; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE script_email (
    id integer NOT NULL,
    subject text NOT NULL,
    sender character varying(75) NOT NULL,
    message text NOT NULL
);


ALTER TABLE public.script_email OWNER TO helpdeskadmin;

--
-- Name: script_email_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE script_email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.script_email_id_seq OWNER TO helpdeskadmin;

--
-- Name: script_email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE script_email_id_seq OWNED BY script_email.id;


--
-- Name: script_email_recipients; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE script_email_recipients (
    id integer NOT NULL,
    email_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.script_email_recipients OWNER TO helpdeskadmin;

--
-- Name: script_email_recipients_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE script_email_recipients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.script_email_recipients_id_seq OWNER TO helpdeskadmin;

--
-- Name: script_email_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE script_email_recipients_id_seq OWNED BY script_email_recipients.id;


--
-- Name: script_script; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE script_script (
    slug character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    enabled boolean NOT NULL
);


ALTER TABLE public.script_script OWNER TO helpdeskadmin;

--
-- Name: script_script_sites; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE script_script_sites (
    id integer NOT NULL,
    script_id character varying(64) NOT NULL,
    site_id integer NOT NULL
);


ALTER TABLE public.script_script_sites OWNER TO helpdeskadmin;

--
-- Name: script_script_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE script_script_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.script_script_sites_id_seq OWNER TO helpdeskadmin;

--
-- Name: script_script_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE script_script_sites_id_seq OWNED BY script_script_sites.id;


--
-- Name: script_scriptprogress; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE script_scriptprogress (
    id integer NOT NULL,
    connection_id integer NOT NULL,
    script_id character varying(64) NOT NULL,
    step_id integer,
    status character varying(1) NOT NULL,
    "time" timestamp with time zone NOT NULL,
    num_tries integer,
    language character varying(5)
);


ALTER TABLE public.script_scriptprogress OWNER TO helpdeskadmin;

--
-- Name: script_scriptprogress_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE script_scriptprogress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.script_scriptprogress_id_seq OWNER TO helpdeskadmin;

--
-- Name: script_scriptprogress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE script_scriptprogress_id_seq OWNED BY script_scriptprogress.id;


--
-- Name: script_scriptresponse; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE script_scriptresponse (
    id integer NOT NULL,
    session_id integer NOT NULL,
    response_id integer NOT NULL
);


ALTER TABLE public.script_scriptresponse OWNER TO helpdeskadmin;

--
-- Name: script_scriptresponse_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE script_scriptresponse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.script_scriptresponse_id_seq OWNER TO helpdeskadmin;

--
-- Name: script_scriptresponse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE script_scriptresponse_id_seq OWNED BY script_scriptresponse.id;


--
-- Name: script_scriptsession; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE script_scriptsession (
    id integer NOT NULL,
    connection_id integer NOT NULL,
    script_id character varying(64) NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone
);


ALTER TABLE public.script_scriptsession OWNER TO helpdeskadmin;

--
-- Name: script_scriptsession_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE script_scriptsession_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.script_scriptsession_id_seq OWNER TO helpdeskadmin;

--
-- Name: script_scriptsession_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE script_scriptsession_id_seq OWNED BY script_scriptsession.id;


--
-- Name: script_scriptstep; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE script_scriptstep (
    id integer NOT NULL,
    script_id character varying(64) NOT NULL,
    poll_id integer,
    message character varying(160) NOT NULL,
    email_id integer,
    "order" integer NOT NULL,
    rule character varying(1) NOT NULL,
    start_offset integer,
    retry_offset integer,
    giveup_offset integer,
    num_tries integer
);


ALTER TABLE public.script_scriptstep OWNER TO helpdeskadmin;

--
-- Name: script_scriptstep_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE script_scriptstep_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.script_scriptstep_id_seq OWNER TO helpdeskadmin;

--
-- Name: script_scriptstep_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE script_scriptstep_id_seq OWNED BY script_scriptstep.id;


--
-- Name: south_migrationhistory; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE south_migrationhistory (
    id integer NOT NULL,
    app_name character varying(255) NOT NULL,
    migration character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.south_migrationhistory OWNER TO helpdeskadmin;

--
-- Name: south_migrationhistory_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE south_migrationhistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.south_migrationhistory_id_seq OWNER TO helpdeskadmin;

--
-- Name: south_migrationhistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE south_migrationhistory_id_seq OWNED BY south_migrationhistory.id;


--
-- Name: tastypie_apiaccess; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE tastypie_apiaccess (
    id integer NOT NULL,
    identifier character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    request_method character varying(10) NOT NULL,
    accessed integer NOT NULL,
    CONSTRAINT tastypie_apiaccess_accessed_check CHECK ((accessed >= 0))
);


ALTER TABLE public.tastypie_apiaccess OWNER TO helpdeskadmin;

--
-- Name: tastypie_apiaccess_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE tastypie_apiaccess_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tastypie_apiaccess_id_seq OWNER TO helpdeskadmin;

--
-- Name: tastypie_apiaccess_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE tastypie_apiaccess_id_seq OWNED BY tastypie_apiaccess.id;


--
-- Name: tastypie_apikey; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE tastypie_apikey (
    id integer NOT NULL,
    user_id integer NOT NULL,
    key character varying(256) NOT NULL,
    created timestamp with time zone NOT NULL
);


ALTER TABLE public.tastypie_apikey OWNER TO helpdeskadmin;

--
-- Name: tastypie_apikey_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE tastypie_apikey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tastypie_apikey_id_seq OWNER TO helpdeskadmin;

--
-- Name: tastypie_apikey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE tastypie_apikey_id_seq OWNED BY tastypie_apikey.id;


--
-- Name: uganda_common_access; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE uganda_common_access (
    id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.uganda_common_access OWNER TO helpdeskadmin;

--
-- Name: uganda_common_access_allowed_locations; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE uganda_common_access_allowed_locations (
    id integer NOT NULL,
    access_id integer NOT NULL,
    location_id integer NOT NULL
);


ALTER TABLE public.uganda_common_access_allowed_locations OWNER TO helpdeskadmin;

--
-- Name: uganda_common_access_allowed_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE uganda_common_access_allowed_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uganda_common_access_allowed_locations_id_seq OWNER TO helpdeskadmin;

--
-- Name: uganda_common_access_allowed_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE uganda_common_access_allowed_locations_id_seq OWNED BY uganda_common_access_allowed_locations.id;


--
-- Name: uganda_common_access_allowed_urls; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE uganda_common_access_allowed_urls (
    id integer NOT NULL,
    access_id integer NOT NULL,
    accessurls_id integer NOT NULL
);


ALTER TABLE public.uganda_common_access_allowed_urls OWNER TO helpdeskadmin;

--
-- Name: uganda_common_access_allowed_urls_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE uganda_common_access_allowed_urls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uganda_common_access_allowed_urls_id_seq OWNER TO helpdeskadmin;

--
-- Name: uganda_common_access_allowed_urls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE uganda_common_access_allowed_urls_id_seq OWNED BY uganda_common_access_allowed_urls.id;


--
-- Name: uganda_common_access_groups; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE uganda_common_access_groups (
    id integer NOT NULL,
    access_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.uganda_common_access_groups OWNER TO helpdeskadmin;

--
-- Name: uganda_common_access_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE uganda_common_access_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uganda_common_access_groups_id_seq OWNER TO helpdeskadmin;

--
-- Name: uganda_common_access_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE uganda_common_access_groups_id_seq OWNED BY uganda_common_access_groups.id;


--
-- Name: uganda_common_access_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE uganda_common_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uganda_common_access_id_seq OWNER TO helpdeskadmin;

--
-- Name: uganda_common_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE uganda_common_access_id_seq OWNED BY uganda_common_access.id;


--
-- Name: uganda_common_accessurls; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE uganda_common_accessurls (
    id integer NOT NULL,
    url character varying(100) NOT NULL
);


ALTER TABLE public.uganda_common_accessurls OWNER TO helpdeskadmin;

--
-- Name: uganda_common_accessurls_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE uganda_common_accessurls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uganda_common_accessurls_id_seq OWNER TO helpdeskadmin;

--
-- Name: uganda_common_accessurls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE uganda_common_accessurls_id_seq OWNED BY uganda_common_accessurls.id;


--
-- Name: unregister_blacklist; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE unregister_blacklist (
    id integer NOT NULL,
    connection_id integer NOT NULL
);


ALTER TABLE public.unregister_blacklist OWNER TO helpdeskadmin;

--
-- Name: unregister_blacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE unregister_blacklist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unregister_blacklist_id_seq OWNER TO helpdeskadmin;

--
-- Name: unregister_blacklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE unregister_blacklist_id_seq OWNED BY unregister_blacklist.id;


--
-- Name: ureport_autoreggrouprules; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_autoreggrouprules (
    id integer NOT NULL,
    group_id integer NOT NULL,
    "values" text,
    rule integer,
    closed boolean,
    rule_regex character varying(700)
);


ALTER TABLE public.ureport_autoreggrouprules OWNER TO helpdeskadmin;

--
-- Name: ureport_autoreggrouprules_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_autoreggrouprules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_autoreggrouprules_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_autoreggrouprules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_autoreggrouprules_id_seq OWNED BY ureport_autoreggrouprules.id;


--
-- Name: ureport_contact; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_contact (
    id integer,
    name character varying(100),
    is_caregiver boolean,
    reporting_location_id integer,
    user_id integer,
    mobile character varying(100),
    language character varying(6),
    province character varying(100),
    age interval,
    gender character varying(1),
    facility character varying(50),
    colline character varying(100),
    responses bigint,
    questions bigint,
    incoming bigint,
    connection_pk integer,
    "group" character varying(80),
    dirty boolean,
    expiry timestamp with time zone
);


ALTER TABLE public.ureport_contact OWNER TO helpdeskadmin;

--
-- Name: ureport_equatellocation; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_equatellocation (
    id integer NOT NULL,
    serial character varying(50) NOT NULL,
    segment character varying(50),
    location_id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.ureport_equatellocation OWNER TO helpdeskadmin;

--
-- Name: ureport_equatellocation_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_equatellocation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_equatellocation_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_equatellocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_equatellocation_id_seq OWNED BY ureport_equatellocation.id;


--
-- Name: ureport_ignoredtags; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_ignoredtags (
    id integer NOT NULL,
    poll_id integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE public.ureport_ignoredtags OWNER TO helpdeskadmin;

--
-- Name: ureport_ignoredtags_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_ignoredtags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_ignoredtags_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_ignoredtags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_ignoredtags_id_seq OWNED BY ureport_ignoredtags.id;


--
-- Name: ureport_messageattribute; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_messageattribute (
    id integer NOT NULL,
    name character varying(300) NOT NULL,
    description text
);


ALTER TABLE public.ureport_messageattribute OWNER TO helpdeskadmin;

--
-- Name: ureport_messageattribute_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_messageattribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_messageattribute_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_messageattribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_messageattribute_id_seq OWNED BY ureport_messageattribute.id;


--
-- Name: ureport_messagedetail; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_messagedetail (
    id integer NOT NULL,
    message_id integer NOT NULL,
    attribute_id integer NOT NULL,
    value character varying(500) NOT NULL,
    description text
);


ALTER TABLE public.ureport_messagedetail OWNER TO helpdeskadmin;

--
-- Name: ureport_messagedetail_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_messagedetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_messagedetail_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_messagedetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_messagedetail_id_seq OWNED BY ureport_messagedetail.id;


--
-- Name: ureport_permit; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_permit (
    id integer NOT NULL,
    user_id integer NOT NULL,
    allowed character varying(200) NOT NULL,
    date date NOT NULL
);


ALTER TABLE public.ureport_permit OWNER TO helpdeskadmin;

--
-- Name: ureport_permit_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_permit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_permit_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_permit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_permit_id_seq OWNED BY ureport_permit.id;


--
-- Name: ureport_pollattribute; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_pollattribute (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    key_type character varying(100) NOT NULL,
    "default" character varying(100)
);


ALTER TABLE public.ureport_pollattribute OWNER TO helpdeskadmin;

--
-- Name: ureport_pollattribute_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_pollattribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_pollattribute_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_pollattribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_pollattribute_id_seq OWNED BY ureport_pollattribute.id;


--
-- Name: ureport_pollattribute_values; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_pollattribute_values (
    id integer NOT NULL,
    pollattribute_id integer NOT NULL,
    pollattributevalue_id integer NOT NULL
);


ALTER TABLE public.ureport_pollattribute_values OWNER TO helpdeskadmin;

--
-- Name: ureport_pollattribute_values_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_pollattribute_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_pollattribute_values_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_pollattribute_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_pollattribute_values_id_seq OWNED BY ureport_pollattribute_values.id;


--
-- Name: ureport_pollattributevalue; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_pollattributevalue (
    id integer NOT NULL,
    value character varying(200) NOT NULL,
    poll_id integer NOT NULL
);


ALTER TABLE public.ureport_pollattributevalue OWNER TO helpdeskadmin;

--
-- Name: ureport_pollattributevalue_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_pollattributevalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_pollattributevalue_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_pollattributevalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_pollattributevalue_id_seq OWNED BY ureport_pollattributevalue.id;


--
-- Name: ureport_quotebox; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_quotebox (
    id integer NOT NULL,
    question text NOT NULL,
    quote text NOT NULL,
    quoted text NOT NULL,
    creation_date timestamp with time zone NOT NULL
);


ALTER TABLE public.ureport_quotebox OWNER TO helpdeskadmin;

--
-- Name: ureport_quotebox_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_quotebox_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_quotebox_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_quotebox_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_quotebox_id_seq OWNED BY ureport_quotebox.id;


--
-- Name: ureport_senttomtrac; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_senttomtrac (
    id integer NOT NULL,
    message_id integer NOT NULL,
    sent_on timestamp with time zone NOT NULL
);


ALTER TABLE public.ureport_senttomtrac OWNER TO helpdeskadmin;

--
-- Name: ureport_senttomtrac_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_senttomtrac_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_senttomtrac_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_senttomtrac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_senttomtrac_id_seq OWNED BY ureport_senttomtrac.id;


--
-- Name: ureport_settings; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_settings (
    id integer NOT NULL,
    attribute character varying(50) NOT NULL,
    value character varying(50),
    description text,
    user_id integer
);


ALTER TABLE public.ureport_settings OWNER TO helpdeskadmin;

--
-- Name: ureport_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_settings_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_settings_id_seq OWNED BY ureport_settings.id;


--
-- Name: ureport_topresponses; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ureport_topresponses (
    id integer NOT NULL,
    poll_id integer NOT NULL,
    quote text NOT NULL,
    quoted text NOT NULL
);


ALTER TABLE public.ureport_topresponses OWNER TO helpdeskadmin;

--
-- Name: ureport_topresponses_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ureport_topresponses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ureport_topresponses_id_seq OWNER TO helpdeskadmin;

--
-- Name: ureport_topresponses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ureport_topresponses_id_seq OWNED BY ureport_topresponses.id;


--
-- Name: ussd_field; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ussd_field (
    question_ptr_id character varying(50) NOT NULL,
    field_id integer NOT NULL
);


ALTER TABLE public.ussd_field OWNER TO helpdeskadmin;

--
-- Name: ussd_menu; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ussd_menu (
    screen_ptr_id character varying(50) NOT NULL
);


ALTER TABLE public.ussd_menu OWNER TO helpdeskadmin;

--
-- Name: ussd_navigation; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ussd_navigation (
    id integer NOT NULL,
    screen_id character varying(50) NOT NULL,
    text text NOT NULL,
    response text NOT NULL,
    date timestamp with time zone NOT NULL,
    session_id integer NOT NULL
);


ALTER TABLE public.ussd_navigation OWNER TO helpdeskadmin;

--
-- Name: ussd_navigation_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ussd_navigation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ussd_navigation_id_seq OWNER TO helpdeskadmin;

--
-- Name: ussd_navigation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ussd_navigation_id_seq OWNED BY ussd_navigation.id;


--
-- Name: ussd_question; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ussd_question (
    screen_ptr_id character varying(50) NOT NULL,
    question_text text NOT NULL,
    next_id character varying(50)
);


ALTER TABLE public.ussd_question OWNER TO helpdeskadmin;

--
-- Name: ussd_screen; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ussd_screen (
    slug character varying(50) NOT NULL,
    label character varying(160) NOT NULL,
    "order" integer NOT NULL,
    parent_id character varying(50),
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    CONSTRAINT ussd_screen_level_check CHECK ((level >= 0)),
    CONSTRAINT ussd_screen_lft_check CHECK ((lft >= 0)),
    CONSTRAINT ussd_screen_rght_check CHECK ((rght >= 0)),
    CONSTRAINT ussd_screen_tree_id_check CHECK ((tree_id >= 0))
);


ALTER TABLE public.ussd_screen OWNER TO helpdeskadmin;

--
-- Name: ussd_session; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ussd_session (
    id integer NOT NULL,
    transaction_id character varying(100) NOT NULL,
    connection_id integer NOT NULL
);


ALTER TABLE public.ussd_session OWNER TO helpdeskadmin;

--
-- Name: ussd_session_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ussd_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ussd_session_id_seq OWNER TO helpdeskadmin;

--
-- Name: ussd_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ussd_session_id_seq OWNED BY ussd_session.id;


--
-- Name: ussd_session_submissions; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ussd_session_submissions (
    id integer NOT NULL,
    session_id integer NOT NULL,
    xformsubmission_id integer NOT NULL
);


ALTER TABLE public.ussd_session_submissions OWNER TO helpdeskadmin;

--
-- Name: ussd_session_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: helpdeskadmin
--

CREATE SEQUENCE ussd_session_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ussd_session_submissions_id_seq OWNER TO helpdeskadmin;

--
-- Name: ussd_session_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helpdeskadmin
--

ALTER SEQUENCE ussd_session_submissions_id_seq OWNED BY ussd_session_submissions.id;


--
-- Name: ussd_stubscreen; Type: TABLE; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE TABLE ussd_stubscreen (
    screen_ptr_id character varying(50) NOT NULL,
    terminal boolean NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.ussd_stubscreen OWNER TO helpdeskadmin;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY alerts_export ALTER COLUMN id SET DEFAULT nextval('alerts_export_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY celery_taskmeta ALTER COLUMN id SET DEFAULT nextval('celery_taskmeta_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY celery_tasksetmeta ALTER COLUMN id SET DEFAULT nextval('celery_tasksetmeta_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_flag ALTER COLUMN id SET DEFAULT nextval('contact_flag_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_masstext ALTER COLUMN id SET DEFAULT nextval('contact_masstext_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_masstext_contacts ALTER COLUMN id SET DEFAULT nextval('contact_masstext_contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_masstext_sites ALTER COLUMN id SET DEFAULT nextval('contact_masstext_sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_messageflag ALTER COLUMN id SET DEFAULT nextval('contact_messageflag_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY django_site ALTER COLUMN id SET DEFAULT nextval('django_site_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY djcelery_crontabschedule ALTER COLUMN id SET DEFAULT nextval('djcelery_crontabschedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY djcelery_intervalschedule ALTER COLUMN id SET DEFAULT nextval('djcelery_intervalschedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY djcelery_periodictask ALTER COLUMN id SET DEFAULT nextval('djcelery_periodictask_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY djcelery_taskstate ALTER COLUMN id SET DEFAULT nextval('djcelery_taskstate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY djcelery_workerstate ALTER COLUMN id SET DEFAULT nextval('djcelery_workerstate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_attribute ALTER COLUMN id SET DEFAULT nextval('eav_attribute_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_encounter ALTER COLUMN id SET DEFAULT nextval('eav_encounter_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_enumgroup ALTER COLUMN id SET DEFAULT nextval('eav_enumgroup_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_enumgroup_enums ALTER COLUMN id SET DEFAULT nextval('eav_enumgroup_enums_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_enumvalue ALTER COLUMN id SET DEFAULT nextval('eav_enumvalue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_patient ALTER COLUMN id SET DEFAULT nextval('eav_patient_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_value ALTER COLUMN id SET DEFAULT nextval('eav_value_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY generic_dashboard ALTER COLUMN id SET DEFAULT nextval('generic_dashboard_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY generic_module ALTER COLUMN id SET DEFAULT nextval('generic_module_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY generic_moduleparams ALTER COLUMN id SET DEFAULT nextval('generic_moduleparams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY generic_staticmodulecontent ALTER COLUMN id SET DEFAULT nextval('generic_staticmodulecontent_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY geoserver_basicclasslayer ALTER COLUMN id SET DEFAULT nextval('geoserver_basicclasslayer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY geoserver_emisattendencedata ALTER COLUMN id SET DEFAULT nextval('geoserver_emisattendencedata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY geoserver_pollcategorydata ALTER COLUMN id SET DEFAULT nextval('geoserver_pollcategorydata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY geoserver_polldata ALTER COLUMN id SET DEFAULT nextval('geoserver_polldata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY geoserver_pollresponsedata ALTER COLUMN id SET DEFAULT nextval('geoserver_pollresponsedata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY locations_location ALTER COLUMN id SET DEFAULT nextval('locations_location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY locations_point ALTER COLUMN id SET DEFAULT nextval('locations_point_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY messagelog_message ALTER COLUMN id SET DEFAULT nextval('messagelog_message_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_category ALTER COLUMN id SET DEFAULT nextval('poll_category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll ALTER COLUMN id SET DEFAULT nextval('poll_poll_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll_contacts ALTER COLUMN id SET DEFAULT nextval('poll_poll_contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll_messages ALTER COLUMN id SET DEFAULT nextval('poll_poll_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll_sites ALTER COLUMN id SET DEFAULT nextval('poll_poll_sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_response ALTER COLUMN id SET DEFAULT nextval('poll_response_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_responsecategory ALTER COLUMN id SET DEFAULT nextval('poll_responsecategory_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_rule ALTER COLUMN id SET DEFAULT nextval('poll_rule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_translation ALTER COLUMN id SET DEFAULT nextval('poll_translation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_app ALTER COLUMN id SET DEFAULT nextval('rapidsms_app_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_backend ALTER COLUMN id SET DEFAULT nextval('rapidsms_backend_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_connection ALTER COLUMN id SET DEFAULT nextval('rapidsms_connection_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact ALTER COLUMN id SET DEFAULT nextval('rapidsms_contact_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact_groups ALTER COLUMN id SET DEFAULT nextval('rapidsms_contact_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact_user_permissions ALTER COLUMN id SET DEFAULT nextval('rapidsms_contact_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_httprouter_deliveryerror ALTER COLUMN id SET DEFAULT nextval('rapidsms_httprouter_deliveryerror_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_httprouter_message ALTER COLUMN id SET DEFAULT nextval('rapidsms_httprouter_message_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_httprouter_messagebatch ALTER COLUMN id SET DEFAULT nextval('rapidsms_httprouter_messagebatch_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_binaryvalue ALTER COLUMN id SET DEFAULT nextval('rapidsms_xforms_binaryvalue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xform ALTER COLUMN id SET DEFAULT nextval('rapidsms_xforms_xform_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xform_restrict_to ALTER COLUMN id SET DEFAULT nextval('rapidsms_xforms_xform_restrict_to_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformfieldconstraint ALTER COLUMN id SET DEFAULT nextval('rapidsms_xforms_xformfieldconstraint_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformlist ALTER COLUMN id SET DEFAULT nextval('rapidsms_xforms_xformlist_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformreport ALTER COLUMN id SET DEFAULT nextval('rapidsms_xforms_xformreport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformreportsubmission ALTER COLUMN id SET DEFAULT nextval('rapidsms_xforms_xformreportsubmission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformreportsubmission_submissions ALTER COLUMN id SET DEFAULT nextval('rapidsms_xforms_xformreportsubmission_submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformsubmission ALTER COLUMN id SET DEFAULT nextval('rapidsms_xforms_xformsubmission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_email ALTER COLUMN id SET DEFAULT nextval('script_email_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_email_recipients ALTER COLUMN id SET DEFAULT nextval('script_email_recipients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_script_sites ALTER COLUMN id SET DEFAULT nextval('script_script_sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptprogress ALTER COLUMN id SET DEFAULT nextval('script_scriptprogress_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptresponse ALTER COLUMN id SET DEFAULT nextval('script_scriptresponse_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptsession ALTER COLUMN id SET DEFAULT nextval('script_scriptsession_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptstep ALTER COLUMN id SET DEFAULT nextval('script_scriptstep_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY south_migrationhistory ALTER COLUMN id SET DEFAULT nextval('south_migrationhistory_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY tastypie_apiaccess ALTER COLUMN id SET DEFAULT nextval('tastypie_apiaccess_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY tastypie_apikey ALTER COLUMN id SET DEFAULT nextval('tastypie_apikey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access ALTER COLUMN id SET DEFAULT nextval('uganda_common_access_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access_allowed_locations ALTER COLUMN id SET DEFAULT nextval('uganda_common_access_allowed_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access_allowed_urls ALTER COLUMN id SET DEFAULT nextval('uganda_common_access_allowed_urls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access_groups ALTER COLUMN id SET DEFAULT nextval('uganda_common_access_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_accessurls ALTER COLUMN id SET DEFAULT nextval('uganda_common_accessurls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY unregister_blacklist ALTER COLUMN id SET DEFAULT nextval('unregister_blacklist_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_autoreggrouprules ALTER COLUMN id SET DEFAULT nextval('ureport_autoreggrouprules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_equatellocation ALTER COLUMN id SET DEFAULT nextval('ureport_equatellocation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_ignoredtags ALTER COLUMN id SET DEFAULT nextval('ureport_ignoredtags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_messageattribute ALTER COLUMN id SET DEFAULT nextval('ureport_messageattribute_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_messagedetail ALTER COLUMN id SET DEFAULT nextval('ureport_messagedetail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_permit ALTER COLUMN id SET DEFAULT nextval('ureport_permit_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_pollattribute ALTER COLUMN id SET DEFAULT nextval('ureport_pollattribute_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_pollattribute_values ALTER COLUMN id SET DEFAULT nextval('ureport_pollattribute_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_pollattributevalue ALTER COLUMN id SET DEFAULT nextval('ureport_pollattributevalue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_quotebox ALTER COLUMN id SET DEFAULT nextval('ureport_quotebox_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_senttomtrac ALTER COLUMN id SET DEFAULT nextval('ureport_senttomtrac_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_settings ALTER COLUMN id SET DEFAULT nextval('ureport_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_topresponses ALTER COLUMN id SET DEFAULT nextval('ureport_topresponses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_navigation ALTER COLUMN id SET DEFAULT nextval('ussd_navigation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_session ALTER COLUMN id SET DEFAULT nextval('ussd_session_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_session_submissions ALTER COLUMN id SET DEFAULT nextval('ussd_session_submissions_id_seq'::regclass);


--
-- Data for Name: alerts_export; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY alerts_export (id, name, district, message, direction, date, mobile, rating, replied, forwarded) FROM stdin;
\.


--
-- Name: alerts_export_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('alerts_export_id_seq', 1, false);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY auth_group (id, name) FROM stdin;
1	GroupeAvecTousLesDroits
2	G1
3	G2
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('auth_group_id_seq', 3, true);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	1	5
6	1	6
7	1	7
8	1	8
9	1	9
10	1	10
11	1	11
12	1	12
13	1	13
14	1	14
15	1	15
16	1	16
17	1	17
18	1	18
19	1	19
20	1	20
21	1	21
22	1	22
23	1	23
24	1	24
25	1	25
26	1	26
27	1	27
28	1	28
29	1	29
30	1	30
31	1	31
32	1	32
33	1	33
34	1	34
35	1	35
36	1	36
37	1	37
38	1	38
39	1	39
40	1	40
41	1	41
42	1	42
43	1	43
44	1	44
45	1	45
46	1	46
47	1	47
48	1	48
49	1	49
50	1	50
51	1	51
52	1	52
53	1	53
54	1	54
55	1	55
56	1	56
57	1	57
58	1	58
59	1	59
60	1	60
61	1	61
62	1	62
63	1	63
64	1	64
65	1	65
66	1	66
67	1	67
68	1	68
69	1	69
70	1	70
71	1	71
72	1	72
73	1	73
74	1	74
75	1	75
76	1	76
77	1	77
78	1	78
79	1	79
80	1	80
81	1	81
82	1	82
83	1	83
84	1	84
85	1	85
86	1	86
87	1	87
88	1	88
89	1	89
90	1	90
91	1	91
92	1	92
93	1	93
94	1	94
95	1	95
96	1	96
97	1	97
98	1	98
99	1	99
100	1	100
101	1	101
102	1	102
103	1	103
104	1	104
105	1	105
106	1	106
107	1	107
108	1	108
109	1	109
110	1	110
111	1	111
112	1	112
113	1	113
114	1	114
115	1	115
116	1	116
117	1	117
118	1	118
119	1	119
120	1	120
121	1	121
122	1	122
123	1	123
124	1	124
125	1	125
126	1	126
127	1	127
128	1	128
129	1	129
130	1	130
131	1	131
132	1	132
133	1	133
134	1	134
135	1	135
136	1	136
137	1	137
138	1	138
139	1	139
140	1	140
141	1	141
142	1	142
143	1	143
144	1	144
145	1	145
146	1	146
147	1	147
148	1	148
149	1	149
150	1	150
151	1	151
152	1	152
153	1	153
154	1	154
155	1	155
156	1	156
157	1	157
158	1	158
159	1	159
160	1	160
161	1	161
162	1	162
163	1	163
164	1	164
165	1	165
166	1	166
167	1	167
168	1	168
169	1	169
170	1	170
171	1	171
172	1	172
173	1	173
174	1	174
175	1	175
176	1	176
177	1	177
178	1	178
179	1	179
180	1	180
181	1	181
182	1	182
183	1	183
184	1	184
185	1	185
186	1	186
187	1	187
188	1	188
189	1	189
190	1	190
191	1	191
192	1	192
193	1	193
194	1	194
195	1	195
196	1	196
197	1	197
198	1	198
199	1	199
200	1	200
201	1	201
202	1	202
203	1	203
204	1	204
205	1	205
206	1	206
207	1	207
208	1	208
209	1	209
210	1	210
211	1	211
212	1	212
213	1	213
214	1	214
215	1	215
216	1	216
217	1	217
218	1	218
219	1	219
220	1	220
221	1	221
222	1	222
223	1	223
224	1	224
225	1	225
226	1	226
227	1	227
228	1	228
229	1	229
230	1	230
231	1	231
232	1	232
233	1	233
234	1	234
235	1	235
236	1	236
237	1	237
238	1	238
239	1	239
240	1	240
241	1	241
242	1	242
243	1	243
244	1	244
245	1	245
246	1	246
247	1	247
248	1	248
249	1	249
250	1	250
251	1	251
252	1	252
253	1	253
254	1	254
255	1	255
256	1	256
257	1	257
258	1	258
259	1	259
260	1	260
261	1	261
262	1	262
263	1	263
264	1	264
265	1	265
266	1	266
267	1	267
268	1	268
269	1	269
270	1	270
271	1	271
272	1	272
273	1	273
274	1	274
275	1	275
276	1	276
277	1	277
278	1	278
279	1	279
280	1	280
281	1	281
282	1	282
283	1	283
284	1	284
285	1	285
286	1	286
287	1	287
288	1	288
289	1	289
290	1	290
291	1	291
292	1	292
293	1	293
294	1	294
295	1	295
296	1	296
297	1	297
298	1	298
299	1	299
300	1	300
301	1	301
302	1	302
303	1	303
304	2	1
305	2	2
306	2	3
307	2	4
308	2	5
309	2	6
310	2	7
311	2	8
312	2	9
313	2	10
314	2	11
315	2	12
316	2	13
317	2	14
318	2	15
319	2	16
320	2	17
321	2	18
322	2	19
323	2	20
324	2	21
325	2	22
326	2	23
327	2	24
328	2	25
329	2	26
330	2	27
331	2	28
332	2	29
333	2	30
334	2	31
335	2	32
336	2	33
337	2	34
338	2	35
339	2	36
340	2	37
341	2	38
342	2	39
343	2	40
344	2	41
345	2	42
346	2	43
347	2	44
348	2	45
349	2	46
350	2	47
351	2	48
352	2	49
353	2	50
354	2	51
355	2	52
356	2	53
357	2	54
358	2	55
359	2	56
360	2	57
361	2	58
362	2	59
363	2	60
364	2	61
365	2	62
366	2	63
367	2	64
368	2	65
369	2	66
370	2	67
371	2	68
372	2	69
373	2	70
374	2	71
375	2	72
376	2	73
377	2	74
378	2	75
379	2	76
380	2	77
381	2	78
382	2	79
383	2	80
384	2	81
385	2	82
386	2	83
387	2	84
388	2	85
389	2	86
390	2	87
391	2	88
392	2	89
393	2	90
394	2	91
395	2	92
396	2	93
397	2	94
398	2	95
399	2	96
400	2	97
401	2	98
402	2	99
403	2	100
404	2	101
405	2	102
406	2	103
407	2	104
408	2	105
409	2	106
410	2	107
411	2	108
412	2	109
413	2	110
414	2	111
415	2	112
416	2	113
417	2	114
418	2	115
419	2	116
420	2	117
421	2	118
422	2	119
423	2	120
424	2	121
425	2	122
426	2	123
427	2	124
428	2	125
429	2	126
430	2	127
431	2	128
432	2	129
433	2	130
434	2	131
435	2	132
436	2	133
437	2	134
438	2	135
439	2	136
440	2	137
441	2	138
442	2	139
443	2	140
444	2	141
445	2	142
446	2	143
447	2	144
448	2	145
449	2	146
450	2	147
451	2	148
452	2	149
453	2	150
454	2	151
455	2	152
456	2	153
457	2	154
458	2	155
459	2	156
460	2	157
461	2	158
462	2	159
463	2	160
464	2	161
465	2	162
466	2	163
467	2	164
468	2	165
469	2	166
470	2	167
471	2	168
472	2	169
473	2	170
474	2	171
475	2	172
476	2	173
477	2	174
478	2	175
479	2	176
480	2	177
481	2	178
482	2	179
483	2	180
484	2	181
485	2	182
486	2	183
487	2	184
488	2	185
489	2	186
490	2	187
491	2	188
492	2	189
493	2	190
494	2	191
495	2	192
496	2	193
497	2	194
498	2	195
499	2	196
500	2	197
501	2	198
502	2	199
503	2	200
504	2	201
505	2	202
506	2	203
507	2	204
508	2	205
509	2	206
510	2	207
511	2	208
512	2	209
513	2	210
514	2	211
515	2	212
516	2	213
517	2	214
518	2	215
519	2	216
520	2	217
521	2	218
522	2	219
523	2	220
524	2	221
525	2	222
526	2	223
527	2	224
528	2	225
529	2	226
530	2	227
531	2	228
532	2	229
533	2	230
534	2	231
535	2	232
536	2	233
537	2	234
538	2	235
539	2	236
540	2	237
541	2	238
542	2	239
543	2	240
544	2	241
545	2	242
546	2	243
547	2	244
548	2	245
549	2	246
550	2	247
551	2	248
552	2	249
553	2	250
554	2	251
555	2	252
556	2	253
557	2	254
558	2	255
559	2	256
560	2	257
561	2	258
562	2	259
563	2	260
564	2	261
565	2	262
566	2	263
567	2	264
568	2	265
569	2	266
570	2	267
571	2	268
572	2	269
573	2	270
574	2	271
575	2	272
576	2	273
577	2	274
578	2	275
579	2	276
580	2	277
581	2	278
582	2	279
583	2	280
584	2	281
585	2	282
586	2	283
587	2	284
588	2	285
589	2	286
590	2	287
591	2	288
592	2	289
593	2	290
594	2	291
595	2	292
596	2	293
597	2	294
598	2	295
599	2	296
600	2	297
601	2	298
602	2	299
603	2	300
604	2	301
605	2	302
606	2	303
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 606, true);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can add group	2	add_group
5	Can change group	2	change_group
6	Can delete group	2	delete_group
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add content type	4	add_contenttype
11	Can change content type	4	change_contenttype
12	Can delete content type	4	delete_contenttype
13	Can add session	5	add_session
14	Can change session	5	change_session
15	Can delete session	5	delete_session
16	Can add site	6	add_site
17	Can change site	6	change_site
18	Can delete site	6	delete_site
19	Can add log entry	7	add_logentry
20	Can change log entry	7	change_logentry
21	Can delete log entry	7	delete_logentry
22	Can add point	8	add_point
23	Can change point	8	change_point
24	Can delete point	8	delete_point
25	Can add location type	9	add_locationtype
26	Can change location type	9	change_locationtype
27	Can delete location type	9	delete_locationtype
28	Can add location	10	add_location
29	Can change location	10	change_location
30	Can delete location	10	delete_location
31	Can add backend	11	add_backend
32	Can change backend	11	change_backend
33	Can delete backend	11	delete_backend
34	Can add app	12	add_app
35	Can change app	12	change_app
36	Can delete app	12	delete_app
37	Can add contact	13	add_contact
38	Can change contact	13	change_contact
39	Can delete contact	13	delete_contact
40	Can add connection	14	add_connection
41	Can change connection	14	change_connection
42	Can delete connection	14	delete_connection
43	Can add message	15	add_message
44	Can change message	15	change_message
45	Can delete message	15	delete_message
46	Can add enum value	16	add_enumvalue
47	Can change enum value	16	change_enumvalue
48	Can delete enum value	16	delete_enumvalue
49	Can add enum group	17	add_enumgroup
50	Can change enum group	17	change_enumgroup
51	Can delete enum group	17	delete_enumgroup
52	Can add attribute	18	add_attribute
53	Can change attribute	18	change_attribute
54	Can delete attribute	18	delete_attribute
55	Can add value	19	add_value
56	Can change value	19	change_value
57	Can delete value	19	delete_value
58	Can add patient	20	add_patient
59	Can change patient	20	change_patient
60	Can delete patient	20	delete_patient
61	Can add encounter	21	add_encounter
62	Can change encounter	21	change_encounter
63	Can delete encounter	21	delete_encounter
64	Can add blacklist	22	add_blacklist
65	Can change blacklist	22	change_blacklist
66	Can delete blacklist	22	delete_blacklist
67	Can add migration history	23	add_migrationhistory
68	Can change migration history	23	change_migrationhistory
69	Can delete migration history	23	delete_migrationhistory
70	Can add task state	24	add_taskmeta
71	Can change task state	24	change_taskmeta
72	Can delete task state	24	delete_taskmeta
73	Can add saved group result	25	add_tasksetmeta
74	Can change saved group result	25	change_tasksetmeta
75	Can delete saved group result	25	delete_tasksetmeta
76	Can add interval	26	add_intervalschedule
77	Can change interval	26	change_intervalschedule
78	Can delete interval	26	delete_intervalschedule
79	Can add crontab	27	add_crontabschedule
80	Can change crontab	27	change_crontabschedule
81	Can delete crontab	27	delete_crontabschedule
82	Can add periodic tasks	28	add_periodictasks
83	Can change periodic tasks	28	change_periodictasks
84	Can delete periodic tasks	28	delete_periodictasks
85	Can add periodic task	29	add_periodictask
86	Can change periodic task	29	change_periodictask
87	Can delete periodic task	29	delete_periodictask
88	Can add worker	30	add_workerstate
89	Can change worker	30	change_workerstate
90	Can delete worker	30	delete_workerstate
91	Can add task	31	add_taskstate
92	Can change task	31	change_taskstate
93	Can delete task	31	delete_taskstate
94	Can add api access	32	add_apiaccess
95	Can change api access	32	change_apiaccess
96	Can delete api access	32	delete_apiaccess
97	Can add api key	33	add_apikey
98	Can change api key	33	change_apikey
99	Can delete api key	33	delete_apikey
100	Can add message batch	34	add_messagebatch
101	Can change message batch	34	change_messagebatch
102	Can delete message batch	34	delete_messagebatch
103	Can add message	35	add_message
104	Can change message	35	change_message
105	Can delete message	35	delete_message
106	Can add delivery error	36	add_deliveryerror
107	Can change delivery error	36	change_deliveryerror
108	Can delete delivery error	36	delete_deliveryerror
109	Can add response category	37	add_responsecategory
110	Can change response category	37	change_responsecategory
111	Can delete response category	37	delete_responsecategory
112	Can add poll	38	add_poll
113	Can change poll	38	change_poll
114	Can delete poll	38	delete_poll
115	Can send polls	38	can_poll
116	Can edit poll rules, categories, and responses	38	can_edit_poll
117	Can add category	39	add_category
118	Can change category	39	change_category
119	Can delete category	39	delete_category
120	Can add response	40	add_response
121	Can change response	40	change_response
122	Can delete response	40	delete_response
123	Can add rule	41	add_rule
124	Can change rule	41	change_rule
125	Can delete rule	41	delete_rule
126	Can add translation	42	add_translation
127	Can change translation	42	change_translation
128	Can delete translation	42	delete_translation
129	Can add ignored tags	43	add_ignoredtags
130	Can change ignored tags	43	change_ignoredtags
131	Can delete ignored tags	43	delete_ignoredtags
132	Can add quote box	44	add_quotebox
133	Can change quote box	44	change_quotebox
134	Can delete quote box	44	delete_quotebox
135	Can add top responses	45	add_topresponses
136	Can change top responses	45	change_topresponses
137	Can delete top responses	45	delete_topresponses
138	Can add equatel location	46	add_equatellocation
139	Can change equatel location	46	change_equatellocation
140	Can delete equatel location	46	delete_equatellocation
141	Can add permit	47	add_permit
142	Can change permit	47	change_permit
143	Can delete permit	47	delete_permit
144	Can add ureporter	13	add_ureporter
145	Can change ureporter	13	change_ureporter
146	Can delete ureporter	13	delete_ureporter
147	can view private info	13	view_numbers
148	can view only particular pages	13	restricted_access
149	can view filters	13	can_filter
150	can view actions	13	can_action
151	can view numbers	13	view_number
152	can view exports	13	can_export
153	can forward messages	13	can_forward
154	Can add message attribute	48	add_messageattribute
155	Can change message attribute	48	change_messageattribute
156	Can delete message attribute	48	delete_messageattribute
157	Can add message detail	49	add_messagedetail
158	Can change message detail	49	change_messagedetail
159	Can delete message detail	49	delete_messagedetail
160	Can add settings	50	add_settings
161	Can change settings	50	change_settings
162	Can delete settings	50	delete_settings
163	Can add autoreg group rules	51	add_autoreggrouprules
164	Can change autoreg group rules	51	change_autoreggrouprules
165	Can delete autoreg group rules	51	delete_autoreggrouprules
166	Can add u poll	38	add_upoll
167	Can change u poll	38	change_upoll
168	Can delete u poll	38	delete_upoll
169	Can add poll attribute value	52	add_pollattributevalue
170	Can change poll attribute value	52	change_pollattributevalue
171	Can delete poll attribute value	52	delete_pollattributevalue
172	Can add poll attribute	53	add_pollattribute
173	Can change poll attribute	53	change_pollattribute
174	Can delete poll attribute	53	delete_pollattribute
175	Can add sent to mtrac	54	add_senttomtrac
176	Can change sent to mtrac	54	change_senttomtrac
177	Can delete sent to mtrac	54	delete_senttomtrac
178	Can add ureport contact	55	add_ureportcontact
179	Can change ureport contact	55	change_ureportcontact
180	Can delete ureport contact	55	delete_ureportcontact
181	Can add alerts export	56	add_alertsexport
182	Can change alerts export	56	change_alertsexport
183	Can delete alerts export	56	delete_alertsexport
184	Can add script	59	add_script
185	Can change script	59	change_script
186	Can delete script	59	delete_script
187	Can add script step	60	add_scriptstep
188	Can change script step	60	change_scriptstep
189	Can delete script step	60	delete_scriptstep
190	Can add script progress	61	add_scriptprogress
191	Can change script progress	61	change_scriptprogress
192	Can delete script progress	61	delete_scriptprogress
193	Can add script session	62	add_scriptsession
194	Can change script session	62	change_scriptsession
195	Can delete script session	62	delete_scriptsession
196	Can add script response	63	add_scriptresponse
197	Can change script response	63	change_scriptresponse
198	Can delete script response	63	delete_scriptresponse
199	Can add email	64	add_email
200	Can change email	64	change_email
201	Can delete email	64	delete_email
202	Can add x form	65	add_xform
203	Can change x form	65	change_xform
204	Can delete x form	65	delete_xform
205	Can add x form field	66	add_xformfield
206	Can change x form field	66	change_xformfield
207	Can delete x form field	66	delete_xformfield
208	Can add x form field constraint	67	add_xformfieldconstraint
209	Can change x form field constraint	67	change_xformfieldconstraint
210	Can delete x form field constraint	67	delete_xformfieldconstraint
211	Can add x form submission	68	add_xformsubmission
212	Can change x form submission	68	change_xformsubmission
213	Can delete x form submission	68	delete_xformsubmission
214	Can approve xform submission	68	can_approve
215	Can add x form submission value	69	add_xformsubmissionvalue
216	Can change x form submission value	69	change_xformsubmissionvalue
217	Can delete x form submission value	69	delete_xformsubmissionvalue
218	Can add binary value	70	add_binaryvalue
219	Can change binary value	70	change_binaryvalue
220	Can delete binary value	70	delete_binaryvalue
221	Can add x form report	71	add_xformreport
222	Can change x form report	71	change_xformreport
223	Can delete x form report	71	delete_xformreport
224	Can add x form list	72	add_xformlist
225	Can change x form list	72	change_xformlist
226	Can delete x form list	72	delete_xformlist
227	Can add x form report submission	73	add_xformreportsubmission
228	Can change x form report submission	73	change_xformreportsubmission
229	Can delete x form report submission	73	delete_xformreportsubmission
230	Can add dashboard	74	add_dashboard
231	Can change dashboard	74	change_dashboard
232	Can delete dashboard	74	delete_dashboard
233	Can publish dashboards	74	publish_dashboard
234	Can add module	75	add_module
235	Can change module	75	change_module
236	Can delete module	75	delete_module
237	Can add module params	76	add_moduleparams
238	Can change module params	76	change_moduleparams
239	Can delete module params	76	delete_moduleparams
240	Can add static module content	77	add_staticmodulecontent
241	Can change static module content	77	change_staticmodulecontent
242	Can delete static module content	77	delete_staticmodulecontent
243	Can add screen	78	add_screen
244	Can change screen	78	change_screen
245	Can delete screen	78	delete_screen
246	Can add menu	79	add_menu
247	Can change menu	79	change_menu
248	Can delete menu	79	delete_menu
249	Can add question	80	add_question
250	Can change question	80	change_question
251	Can delete question	80	delete_question
252	Can add field	81	add_field
253	Can change field	81	change_field
254	Can delete field	81	delete_field
255	Can add stub screen	82	add_stubscreen
256	Can change stub screen	82	change_stubscreen
257	Can delete stub screen	82	delete_stubscreen
258	Can add session	83	add_session
259	Can change session	83	change_session
260	Can delete session	83	delete_session
261	Can add navigation	84	add_navigation
262	Can change navigation	84	change_navigation
263	Can delete navigation	84	delete_navigation
264	Can add access urls	85	add_accessurls
265	Can change access urls	85	change_accessurls
266	Can delete access urls	85	delete_accessurls
267	Can add access	86	add_access
268	Can change access	86	change_access
269	Can delete access	86	delete_access
270	Can add mass text	87	add_masstext
271	Can change mass text	87	change_masstext
272	Can delete mass text	87	delete_masstext
273	Can send messages, create polls, etc	87	can_message
274	Can add flag	88	add_flag
275	Can change flag	88	change_flag
276	Can delete flag	88	delete_flag
277	Can add message flag	89	add_messageflag
278	Can change message flag	89	change_messageflag
279	Can delete message flag	89	delete_messageflag
280	Can add poll data	90	add_polldata
281	Can change poll data	90	change_polldata
282	Can delete poll data	90	delete_polldata
283	Can add poll category data	91	add_pollcategorydata
284	Can change poll category data	91	change_pollcategorydata
285	Can delete poll category data	91	delete_pollcategorydata
286	Can add poll response data	92	add_pollresponsedata
287	Can change poll response data	92	change_pollresponsedata
288	Can delete poll response data	92	delete_pollresponsedata
289	Can add basic class layer	93	add_basicclasslayer
290	Can change basic class layer	93	change_basicclasslayer
291	Can delete basic class layer	93	delete_basicclasslayer
292	Can add emis attendence data	94	add_emisattendencedata
293	Can change emis attendence data	94	change_emisattendencedata
294	Can delete emis attendence data	94	delete_emisattendencedata
295	Can add ibm category	95	add_ibmcategory
296	Can change ibm category	95	change_ibmcategory
297	Can delete ibm category	95	delete_ibmcategory
298	Can add ibm action	96	add_ibmaction
299	Can change ibm action	96	change_ibmaction
300	Can delete ibm action	96	delete_ibmaction
301	Can add ibm msg category	97	add_ibmmsgcategory
302	Can change ibm msg category	97	change_ibmmsgcategory
303	Can delete ibm msg category	97	delete_ibmmsgcategory
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('auth_permission_id_seq', 303, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY auth_user (id, username, first_name, last_name, email, password, is_staff, is_active, is_superuser, last_login, date_joined) FROM stdin;
2	Utilisateur1	FirstNameUtilisateur1	LastNameUtilisateur1		pbkdf2_sha256$10000$IXb0gFG5AR9J$DDl5ogLjvb81hx6S6MYUzvTy0v4JSZmvD69MLBRCyBg=	f	t	f	2013-10-17 16:13:05+02	2013-10-17 16:13:05+02
3	mbanje	Mbanje	Jean Vernack	mbanjejvernackf@gmail.com	pbkdf2_sha256$10000$9E9b4Zb6ioaJ$UWdwWwU4GaybS1vzUYyTysRdC3PHpC6mK4HIt+vS3SA=	t	t	t	2013-10-17 16:16:47+02	2013-10-17 16:16:47+02
1	helpdeskadmin			a@a.com	pbkdf2_sha256$10000$8p8FFv6AA8b8$lEPmIoBNveLiFps6tFLLP/vKC7WI5cetjIomGRCd59M=	t	t	t	2013-10-24 15:12:02.420825+02	2013-08-02 12:21:59.100617+02
4	hewe				pbkdf2_sha256$10000$GRUKyKYmOybf$MIPARffySQy87uqldBfqVPMb/s6TvYL/rXsmzUUTFmE=	f	t	f	2013-10-25 09:25:55.658272+02	2013-10-25 09:25:55.658285+02
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
2	1	2
3	3	3
4	2	1
5	2	2
6	2	3
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 6, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('auth_user_id_seq', 4, true);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
950	2	19
951	2	20
952	2	21
953	2	4
954	2	5
955	2	6
956	2	1
957	2	2
958	2	3
959	2	7
960	2	8
961	2	9
962	2	274
963	2	275
964	2	276
965	2	270
966	2	273
967	2	271
968	2	272
969	2	277
970	2	278
971	2	279
972	2	10
973	2	11
974	2	12
975	2	79
976	2	80
977	2	81
978	2	76
979	2	77
980	2	78
981	2	85
982	2	86
983	2	87
984	2	82
985	2	83
986	2	84
987	2	70
988	2	71
989	2	72
990	2	73
991	2	74
992	2	75
993	2	91
994	2	92
995	2	93
996	2	88
997	2	89
998	2	90
999	2	52
1000	2	53
1001	2	54
1002	2	61
1003	2	62
1004	2	63
1005	2	49
1006	2	50
1007	2	51
1008	2	46
1009	2	47
1010	2	48
1011	2	58
1012	2	59
1013	2	60
1014	2	55
1015	2	56
1016	2	57
1017	2	230
1018	2	231
1019	2	232
1020	2	233
1021	2	234
1022	2	235
1023	2	236
1024	2	237
1025	2	238
1026	2	239
1027	2	240
1028	2	241
1029	2	242
1030	2	289
1031	2	290
1032	2	291
1033	2	292
1034	2	293
1035	2	294
1036	2	283
1037	2	284
1038	2	285
1039	2	280
1040	2	281
1041	2	282
1042	2	286
1043	2	287
1044	2	288
1045	2	28
1046	2	29
1047	2	30
1048	2	25
1049	2	26
1050	2	27
1051	2	22
1052	2	23
1053	2	24
1054	2	298
1055	2	299
1056	2	300
1057	2	295
1058	2	296
1059	2	297
1060	2	301
1061	2	302
1062	2	303
1063	2	43
1064	2	44
1065	2	45
1066	2	117
1067	2	118
1068	2	119
1069	2	112
1070	2	166
1071	2	116
1072	2	115
1073	2	113
1074	2	167
1075	2	114
1076	2	168
1077	2	120
1078	2	121
1079	2	122
1080	2	109
1081	2	110
1082	2	111
1083	2	123
1084	2	124
1085	2	125
1086	2	126
1087	2	127
1088	2	128
1089	2	34
1090	2	35
1091	2	36
1092	2	31
1093	2	32
1094	2	33
1095	2	40
1096	2	41
1097	2	42
1098	2	37
1099	2	144
1100	2	150
1101	2	152
1102	2	149
1103	2	153
1104	2	38
1105	2	145
1106	2	39
1107	2	146
1108	2	148
1109	2	151
1110	2	147
1111	2	106
1112	2	107
1113	2	108
1114	2	103
1115	2	104
1116	2	105
1117	2	100
1118	2	101
1119	2	102
1120	2	218
1121	2	219
1122	2	220
1123	2	202
1124	2	203
1125	2	204
1126	2	205
1127	2	206
1128	2	207
1129	2	208
1130	2	209
1131	2	210
1132	2	224
1133	2	225
1134	2	226
1135	2	221
1136	2	222
1137	2	223
1138	2	227
1139	2	228
1140	2	229
1141	2	211
1142	2	214
1143	2	212
1144	2	213
1145	2	215
1146	2	216
1147	2	217
1148	2	199
1149	2	200
1150	2	201
1151	2	184
1152	2	185
1153	2	186
1154	2	190
1155	2	191
1156	2	192
1157	2	196
1158	2	197
1159	2	198
1160	2	193
1161	2	194
1162	2	195
1163	2	187
1164	2	188
1165	2	189
1166	2	13
1167	2	14
1168	2	15
1169	2	16
1170	2	17
1171	2	18
1172	2	67
1173	2	68
1174	2	69
1175	2	94
1176	2	95
1177	2	96
1178	2	97
1179	2	98
1180	2	99
1181	2	267
1182	2	268
1183	2	269
1184	2	264
1185	2	265
1186	2	266
1187	2	64
1188	2	65
1189	2	66
1190	2	181
1191	2	182
1192	2	183
1193	2	163
1194	2	164
1195	2	165
1196	2	138
1197	2	139
1198	2	140
1199	2	129
1200	2	130
1201	2	131
1202	2	154
1203	2	155
1204	2	156
1205	2	157
1206	2	158
1207	2	159
1208	2	141
1209	2	142
1210	2	143
1211	2	172
1212	2	173
1213	2	174
1214	2	169
1215	2	170
1216	2	171
1217	2	132
1218	2	133
1219	2	134
1220	2	175
1221	2	176
1222	2	177
1223	2	160
1224	2	161
1225	2	162
1226	2	135
1227	2	136
1228	2	137
1229	2	178
1230	2	179
1231	2	180
1232	2	252
1233	2	253
1234	2	254
1235	2	246
1236	2	247
1237	2	248
1238	2	261
1239	2	262
1240	2	263
1241	2	249
1242	2	250
1243	2	251
1244	2	243
1245	2	244
1246	2	245
1247	2	258
1248	2	259
1249	2	260
1250	2	255
1251	2	256
1252	2	257
607	1	19
608	1	20
609	1	21
610	1	4
611	1	5
612	1	6
613	1	1
614	1	2
615	1	3
616	1	7
617	1	8
618	1	9
619	1	274
620	1	275
621	1	276
622	1	270
623	1	273
624	1	271
625	1	272
626	1	277
627	1	278
628	1	279
629	1	10
630	1	11
631	1	12
632	1	79
633	1	80
634	1	81
635	1	76
636	1	77
637	1	78
638	1	85
639	1	86
640	1	87
641	1	82
642	1	83
643	1	84
644	1	70
645	1	71
646	1	72
647	3	19
648	3	20
649	3	21
650	3	4
651	3	5
652	3	6
653	3	1
654	3	2
655	3	3
656	3	7
657	3	8
658	3	9
659	3	274
660	3	275
661	3	276
662	3	270
663	3	273
664	3	271
665	3	272
666	3	277
667	3	278
668	3	279
669	3	10
670	3	11
671	3	12
672	3	79
673	3	80
674	3	81
675	3	76
676	3	77
677	3	78
678	3	85
679	3	86
680	3	87
681	3	82
682	3	83
683	3	84
684	3	70
685	3	71
686	3	72
687	3	73
688	3	74
689	3	75
690	3	91
691	3	92
692	3	93
693	3	88
694	3	89
695	3	90
696	3	52
697	3	53
698	3	54
699	3	61
700	3	62
701	3	63
702	3	49
703	3	50
704	3	51
705	3	46
706	3	47
707	3	48
708	3	58
709	3	59
710	3	60
711	3	55
712	3	56
713	3	57
714	3	230
715	3	231
716	3	232
717	3	233
718	3	234
719	3	235
720	3	236
721	3	237
722	3	238
723	3	239
724	3	240
725	3	241
726	3	242
727	3	289
728	3	290
729	3	291
730	3	292
731	3	293
732	3	294
733	3	283
734	3	284
735	3	285
736	3	280
737	3	281
738	3	282
739	3	286
740	3	287
741	3	288
742	3	28
743	3	29
744	3	30
745	3	25
746	3	26
747	3	27
748	3	22
749	3	23
750	3	24
751	3	298
752	3	299
753	3	300
754	3	295
755	3	296
756	3	297
757	3	301
758	3	302
759	3	303
760	3	43
761	3	44
762	3	45
763	3	117
764	3	118
765	3	119
766	3	112
767	3	166
768	3	116
769	3	115
770	3	113
771	3	167
772	3	114
773	3	168
774	3	120
775	3	121
776	3	122
777	3	109
778	3	110
779	3	111
780	3	123
781	3	124
782	3	125
783	3	126
784	3	127
785	3	128
786	3	34
787	3	35
788	3	36
789	3	31
790	3	32
791	3	33
792	3	40
793	3	41
794	3	42
795	3	37
796	3	144
797	3	150
798	3	152
799	3	149
800	3	153
801	3	38
802	3	145
803	3	39
804	3	146
805	3	148
806	3	151
807	3	147
808	3	106
809	3	107
810	3	108
811	3	103
812	3	104
813	3	105
814	3	100
815	3	101
816	3	102
817	3	218
818	3	219
819	3	220
820	3	202
821	3	203
822	3	204
823	3	205
824	3	206
825	3	207
826	3	208
827	3	209
828	3	210
829	3	224
830	3	225
831	3	226
832	3	221
833	3	222
834	3	223
835	3	227
836	3	228
837	3	229
838	3	211
839	3	214
840	3	212
841	3	213
842	3	215
843	3	216
844	3	217
845	3	199
846	3	200
847	3	201
848	3	184
849	3	185
850	3	186
851	3	190
852	3	191
853	3	192
854	3	196
855	3	197
856	3	198
857	3	193
858	3	194
859	3	195
860	3	187
861	3	188
862	3	189
863	3	13
864	3	14
865	3	15
866	3	16
867	3	17
868	3	18
869	3	67
870	3	68
871	3	69
872	3	94
873	3	95
874	3	96
875	3	97
876	3	98
877	3	99
878	3	267
879	3	268
880	3	269
881	3	264
882	3	265
883	3	266
884	3	64
885	3	65
886	3	66
887	3	181
888	3	182
889	3	183
890	3	163
891	3	164
892	3	165
893	3	138
894	3	139
895	3	140
896	3	129
897	3	130
898	3	131
899	3	154
900	3	155
901	3	156
902	3	157
903	3	158
904	3	159
905	3	141
906	3	142
907	3	143
908	3	172
909	3	173
910	3	174
911	3	169
912	3	170
913	3	171
914	3	132
915	3	133
916	3	134
917	3	175
918	3	176
919	3	177
920	3	160
921	3	161
922	3	162
923	3	135
924	3	136
925	3	137
926	3	178
927	3	179
928	3	180
929	3	252
930	3	253
931	3	254
932	3	246
933	3	247
934	3	248
935	3	261
936	3	262
937	3	263
938	3	249
939	3	250
940	3	251
941	3	243
942	3	244
943	3	245
944	3	258
945	3	259
946	3	260
947	3	255
948	3	256
949	3	257
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1252, true);


--
-- Data for Name: celery_taskmeta; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY celery_taskmeta (id, task_id, status, result, date_done, traceback, hidden, meta) FROM stdin;
\.


--
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('celery_taskmeta_id_seq', 1, false);


--
-- Data for Name: celery_tasksetmeta; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY celery_tasksetmeta (id, taskset_id, result, date_done, hidden) FROM stdin;
\.


--
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('celery_tasksetmeta_id_seq', 1, false);


--
-- Data for Name: contact_flag; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY contact_flag (id, name, words, rule, rule_regex) FROM stdin;
1	flag1	Word for flag1	1	(?=.*\\bWord\\ for\\ flag1\\b)
2	flag2	word for creating flag2	1	(?=.*\\bword\\ for\\ creating\\ flag2\\b)
\.


--
-- Name: contact_flag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('contact_flag_id_seq', 2, true);


--
-- Data for Name: contact_masstext; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY contact_masstext (id, user_id, date, text) FROM stdin;
\.


--
-- Data for Name: contact_masstext_contacts; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY contact_masstext_contacts (id, masstext_id, contact_id) FROM stdin;
\.


--
-- Name: contact_masstext_contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('contact_masstext_contacts_id_seq', 1, false);


--
-- Name: contact_masstext_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('contact_masstext_id_seq', 1, false);


--
-- Data for Name: contact_masstext_sites; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY contact_masstext_sites (id, masstext_id, site_id) FROM stdin;
\.


--
-- Name: contact_masstext_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('contact_masstext_sites_id_seq', 1, false);


--
-- Data for Name: contact_messageflag; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY contact_messageflag (id, message_id, flag_id) FROM stdin;
\.


--
-- Name: contact_messageflag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('contact_messageflag_id_seq', 1, false);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY django_admin_log (id, action_time, user_id, content_type_id, object_id, object_repr, action_flag, change_message) FROM stdin;
1	2013-10-17 15:50:29.013278+02	1	2	1	GroupeAvecTousLesDroits	1	
2	2013-10-17 16:13:05.825541+02	1	3	2	Utilisateur1	1	
3	2013-10-17 16:15:53.124619+02	1	3	2	Utilisateur1	2	Changed password, first_name, last_name and user_permissions.
4	2013-10-17 16:16:47.708646+02	1	3	3	mbanje	1	
5	2013-10-17 16:18:18.464599+02	1	3	3	mbanje	2	Changed password, first_name, last_name, email, is_staff, is_superuser, groups and user_permissions.
6	2013-10-24 15:03:21.894981+02	1	2	2	G1	1	
7	2013-10-24 15:03:45.716046+02	1	2	3	G2	1	
8	2013-10-24 15:18:23.312441+02	1	88	1	flag1	1	
9	2013-10-24 15:19:36.330006+02	1	88	2	flag2	1	
10	2013-10-24 15:20:31.764504+02	1	12	1	app1	1	
11	2013-10-24 15:20:41.000952+02	1	12	2	app2	1	
12	2013-10-24 15:21:08.456083+02	1	11	2	backend1	1	
13	2013-10-24 15:21:19.801557+02	1	11	3	backend2	1	
14	2013-10-24 15:27:53.02859+02	1	13	1	Contact1	1	
15	2013-10-24 15:29:53.009899+02	1	13	2	Contact2	1	
16	2013-10-24 15:33:08.614586+02	1	6	2	www.site.com	1	
17	2013-10-24 15:35:12.703392+02	1	44	1	QuoteBox object	1	
18	2013-10-24 15:36:07.073633+02	1	44	2	QuoteBox object	1	
19	2013-10-24 15:39:33.775983+02	1	38	1	Name of poll1 Quelle est la ques ...(2013-10-24)	1	
20	2013-10-24 15:42:36.873433+02	1	38	2	Name of poll2 Que est ton sport  ...(2013-10-24)	1	
21	2013-10-24 15:46:02.129813+02	1	40	1	Response object	1	
22	2013-10-24 15:48:47.677502+02	1	40	2	Response object	1	
23	2013-10-24 15:54:39.997681+02	1	39	1	categorie1	1	
24	2013-10-24 15:55:36.779179+02	1	39	2	categorie2	1	
25	2013-10-24 15:56:13.412268+02	1	37	1	ResponseCategory object	1	
26	2013-10-24 15:56:25.717292+02	1	37	2	ResponseCategory object	1	
27	2013-10-24 16:01:34.569867+02	1	41	1	Rule object	1	
28	2013-10-25 09:12:38.342451+02	1	13	3	contact3	1	
29	2013-10-25 09:23:17.05405+02	1	13	4	contact4	1	
30	2013-10-25 09:25:55.871825+02	1	3	4	hewe	1	
31	2013-10-25 09:30:06.665295+02	1	13	5	contact sans user	1	
32	2013-10-25 10:14:11.630808+02	1	15	1	un message (from Contact1)	1	
33	2013-10-25 10:21:10.402553+02	1	15	2	Un incoming message (to Contact1)	1	
34	2013-10-25 10:21:40.779339+02	1	15	3	An outgoing message (from Contact1)	1	
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 34, true);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY django_content_type (id, name, app_label, model) FROM stdin;
1	permission	auth	permission
2	group	auth	group
3	user	auth	user
4	content type	contenttypes	contenttype
5	session	sessions	session
6	site	sites	site
7	log entry	admin	logentry
8	point	locations	point
9	location type	locations	locationtype
10	location	locations	location
11	backend	rapidsms	backend
12	app	rapidsms	app
13	contact	rapidsms	contact
14	connection	rapidsms	connection
15	message	messagelog	message
16	enum value	eav	enumvalue
17	enum group	eav	enumgroup
18	attribute	eav	attribute
19	value	eav	value
20	patient	eav	patient
21	encounter	eav	encounter
22	blacklist	unregister	blacklist
23	migration history	south	migrationhistory
24	task state	djcelery	taskmeta
25	saved group result	djcelery	tasksetmeta
26	interval	djcelery	intervalschedule
27	crontab	djcelery	crontabschedule
28	periodic tasks	djcelery	periodictasks
29	periodic task	djcelery	periodictask
30	worker	djcelery	workerstate
31	task	djcelery	taskstate
32	api access	tastypie	apiaccess
33	api key	tastypie	apikey
34	message batch	rapidsms_httprouter	messagebatch
35	message	rapidsms_httprouter	message
36	delivery error	rapidsms_httprouter	deliveryerror
37	response category	poll	responsecategory
38	poll	poll	poll
39	category	poll	category
40	response	poll	response
41	rule	poll	rule
42	translation	poll	translation
43	ignored tags	ureport	ignoredtags
44	quote box	ureport	quotebox
45	top responses	ureport	topresponses
46	equatel location	ureport	equatellocation
47	permit	ureport	permit
48	message attribute	ureport	messageattribute
49	message detail	ureport	messagedetail
50	settings	ureport	settings
51	autoreg group rules	ureport	autoreggrouprules
52	poll attribute value	ureport	pollattributevalue
53	poll attribute	ureport	pollattribute
54	sent to mtrac	ureport	senttomtrac
55	ureport contact	ureport	ureportcontact
56	alerts export	ureport	alertsexport
57	ureporter	ureport	ureporter
58	u poll	ureport	upoll
59	script	script	script
60	script step	script	scriptstep
61	script progress	script	scriptprogress
62	script session	script	scriptsession
63	script response	script	scriptresponse
64	email	script	email
65	x form	rapidsms_xforms	xform
66	x form field	rapidsms_xforms	xformfield
67	x form field constraint	rapidsms_xforms	xformfieldconstraint
68	x form submission	rapidsms_xforms	xformsubmission
69	x form submission value	rapidsms_xforms	xformsubmissionvalue
70	binary value	rapidsms_xforms	binaryvalue
71	x form report	rapidsms_xforms	xformreport
72	x form list	rapidsms_xforms	xformlist
73	x form report submission	rapidsms_xforms	xformreportsubmission
74	dashboard	generic	dashboard
75	module	generic	module
76	module params	generic	moduleparams
77	static module content	generic	staticmodulecontent
78	screen	ussd	screen
79	menu	ussd	menu
80	question	ussd	question
81	field	ussd	field
82	stub screen	ussd	stubscreen
83	session	ussd	session
84	navigation	ussd	navigation
85	access urls	uganda_common	accessurls
86	access	uganda_common	access
87	mass text	contact	masstext
88	flag	contact	flag
89	message flag	contact	messageflag
90	poll data	geoserver	polldata
91	poll category data	geoserver	pollcategorydata
92	poll response data	geoserver	pollresponsedata
93	basic class layer	geoserver	basicclasslayer
94	emis attendence data	geoserver	emisattendencedata
95	ibm category	message_classifier	ibmcategory
96	ibm action	message_classifier	ibmaction
97	ibm msg category	message_classifier	ibmmsgcategory
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('django_content_type_id_seq', 97, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
3a3b82057fdea4eb832e47d904c2732b	NzhiZTJhNjkxODA5ZmM0YWY2OTgzMjBjMThiM2JhMDQyMWI3Nzg3YjqAAn1xAVUKdGVzdGNvb2tp\nZXECVQZ3b3JrZWRxA3Mu\n	2013-08-29 10:28:23.012043+02
face70746f54c64989e681e590279aee	YmIxYjBhZmJhYjQ5YzU2YjY4MWJkODZhM2E2NDY2N2RmNzEwM2M4ZjqAAn1xAShVDV9hdXRoX3Vz\nZXJfaWRLAVUSX2F1dGhfdXNlcl9iYWNrZW5kVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZFgYAAAAL215cG9sbHMvX2ZpbHRlcl9yZXF1ZXN0TnUu\n	2013-11-08 08:59:11.597098+02
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY django_site (id, domain, name) FROM stdin;
1	example.com	example.com
2	www.site.com	site1
\.


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('django_site_id_seq', 2, true);


--
-- Data for Name: djcelery_crontabschedule; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY djcelery_crontabschedule (id, minute, hour, day_of_week, day_of_month, month_of_year) FROM stdin;
\.


--
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('djcelery_crontabschedule_id_seq', 1, false);


--
-- Data for Name: djcelery_intervalschedule; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY djcelery_intervalschedule (id, every, period) FROM stdin;
\.


--
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('djcelery_intervalschedule_id_seq', 1, false);


--
-- Data for Name: djcelery_periodictask; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY djcelery_periodictask (id, name, task, interval_id, crontab_id, args, kwargs, queue, exchange, routing_key, expires, enabled, last_run_at, total_run_count, date_changed, description) FROM stdin;
\.


--
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('djcelery_periodictask_id_seq', 1, false);


--
-- Data for Name: djcelery_periodictasks; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY djcelery_periodictasks (ident, last_update) FROM stdin;
\.


--
-- Data for Name: djcelery_taskstate; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY djcelery_taskstate (id, state, task_id, name, tstamp, args, kwargs, eta, expires, result, traceback, runtime, retries, worker_id, hidden) FROM stdin;
\.


--
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('djcelery_taskstate_id_seq', 1, false);


--
-- Data for Name: djcelery_workerstate; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY djcelery_workerstate (id, hostname, last_heartbeat) FROM stdin;
\.


--
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('djcelery_workerstate_id_seq', 1, false);


--
-- Data for Name: eav_attribute; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY eav_attribute (id, name, site_id, slug, description, enum_group_id, type, datatype, created, modified, required) FROM stdin;
1	Number	1	poll_number_value	A response value for a Poll with expected numeric responses	\N	\N	float	2011-08-03 11:17:01+02	2011-08-03 11:17:02+02	f
2	Text	1	poll_text_value	A response value for a Poll with expected text responses	\N	\N	text	2011-08-03 11:17:02+02	2011-08-03 11:17:02+02	f
3	Location	1	poll_location_value	A response value for a Poll with expected location-based responses	\N	\N	object	2011-08-03 11:17:02+02	2011-08-03 11:17:02+02	f
4	Location	1	contact_location	The location associated with a particular contact	\N	\N	object	2011-08-03 11:17:02+02	2011-08-03 11:17:02+02	f
\.


--
-- Name: eav_attribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('eav_attribute_id_seq', 4, true);


--
-- Data for Name: eav_encounter; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY eav_encounter (id, num, patient_id) FROM stdin;
\.


--
-- Name: eav_encounter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('eav_encounter_id_seq', 1, false);


--
-- Data for Name: eav_enumgroup; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY eav_enumgroup (id, name) FROM stdin;
\.


--
-- Data for Name: eav_enumgroup_enums; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY eav_enumgroup_enums (id, enumgroup_id, enumvalue_id) FROM stdin;
\.


--
-- Name: eav_enumgroup_enums_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('eav_enumgroup_enums_id_seq', 1, false);


--
-- Name: eav_enumgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('eav_enumgroup_id_seq', 1, false);


--
-- Data for Name: eav_enumvalue; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY eav_enumvalue (id, value) FROM stdin;
\.


--
-- Name: eav_enumvalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('eav_enumvalue_id_seq', 1, false);


--
-- Data for Name: eav_patient; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY eav_patient (id, name) FROM stdin;
\.


--
-- Name: eav_patient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('eav_patient_id_seq', 1, false);


--
-- Data for Name: eav_value; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY eav_value (id, entity_ct_id, entity_id, value_text, value_float, value_int, value_date, value_bool, value_enum_id, generic_value_id, generic_value_ct_id, created, modified, attribute_id) FROM stdin;
\.


--
-- Name: eav_value_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('eav_value_id_seq', 1, false);


--
-- Data for Name: generic_dashboard; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY generic_dashboard (id, user_id, slug) FROM stdin;
\.


--
-- Name: generic_dashboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('generic_dashboard_id_seq', 1, false);


--
-- Data for Name: generic_module; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY generic_module (id, dashboard_id, title, view_name, "offset", "column") FROM stdin;
\.


--
-- Name: generic_module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('generic_module_id_seq', 1, false);


--
-- Data for Name: generic_moduleparams; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY generic_moduleparams (id, module_id, param_name, param_value, is_url_param) FROM stdin;
\.


--
-- Name: generic_moduleparams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('generic_moduleparams_id_seq', 1, false);


--
-- Data for Name: generic_staticmodulecontent; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY generic_staticmodulecontent (id, content) FROM stdin;
\.


--
-- Name: generic_staticmodulecontent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('generic_staticmodulecontent_id_seq', 1, false);


--
-- Data for Name: geoserver_basicclasslayer; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY geoserver_basicclasslayer (id, district, style_class, deployment_id, layer_id, description) FROM stdin;
\.


--
-- Name: geoserver_basicclasslayer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('geoserver_basicclasslayer_id_seq', 1, false);


--
-- Data for Name: geoserver_emisattendencedata; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY geoserver_emisattendencedata (id, district, start_date, end_date, boys, girls, total_pupils, female_teachers, male_teachers, total_teachers) FROM stdin;
\.


--
-- Name: geoserver_emisattendencedata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('geoserver_emisattendencedata_id_seq', 1, false);


--
-- Data for Name: geoserver_pollcategorydata; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY geoserver_pollcategorydata (id, district, poll_id, deployment_id, top_category, description) FROM stdin;
\.


--
-- Name: geoserver_pollcategorydata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('geoserver_pollcategorydata_id_seq', 1, false);


--
-- Data for Name: geoserver_polldata; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY geoserver_polldata (id, district, poll_id, deployment_id, yes, no, uncategorized, unknown) FROM stdin;
\.


--
-- Name: geoserver_polldata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('geoserver_polldata_id_seq', 1, false);


--
-- Data for Name: geoserver_pollresponsedata; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY geoserver_pollresponsedata (id, district, poll_id, deployment_id, percentage) FROM stdin;
\.


--
-- Name: geoserver_pollresponsedata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('geoserver_pollresponsedata_id_seq', 1, false);


--
-- Data for Name: ibm_action; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ibm_action (action_id, name) FROM stdin;
\.


--
-- Data for Name: ibm_category; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ibm_category (category_id, name) FROM stdin;
1	education
2	emergency
3	employment
4	energy
5	family & relationships
6	health & nutrition
7	irrelevant
8	ovc
9	social policy
10	u-report
11	violence against children
12	water
\.


--
-- Data for Name: ibm_msg_category; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ibm_msg_category (msg_id, category_id, score, action_id) FROM stdin;
\.


--
-- Data for Name: locations_location; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY locations_location (id, point_id, type_id, parent_type_id, parent_id, tree_parent_id, name, status, code, is_active, lft, rght, tree_id, level) FROM stdin;
\.


--
-- Name: locations_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('locations_location_id_seq', 1, false);


--
-- Data for Name: locations_locationtype; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY locations_locationtype (name, slug) FROM stdin;
\.


--
-- Data for Name: locations_point; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY locations_point (id, latitude, longitude) FROM stdin;
\.


--
-- Name: locations_point_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('locations_point_id_seq', 1, false);


--
-- Data for Name: messagelog_message; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY messagelog_message (id, contact_id, connection_id, direction, date, text) FROM stdin;
1	1	2	O	2013-10-25 10:12:48+02	un message
2	1	2	I	2013-10-25 10:20:57+02	Un incoming message
3	1	2	O	2013-10-25 10:21:26+02	An outgoing message
\.


--
-- Name: messagelog_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('messagelog_message_id_seq', 3, true);


--
-- Data for Name: poll_category; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY poll_category (id, name, poll_id, priority, color, "default", response, error_category) FROM stdin;
1	categorie1	1	1	red	t	respose r1	f
2	categorie2	2	2	green	t	response2	f
\.


--
-- Name: poll_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('poll_category_id_seq', 2, true);


--
-- Data for Name: poll_poll; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY poll_poll (id, name, question, user_id, start_date, end_date, type, default_response, response_type) FROM stdin;
1	Name of poll1	Quelle est la question qui preoccupe de plus les jeunes Burundais?	1	2013-10-24 15:38:06+02	2013-10-25 12:00:00+02		Emploi	a
2	Name of poll2	Que est ton sport prefere	3	2013-10-24 15:41:51+02	2013-10-25 06:00:00+02			a
\.


--
-- Data for Name: poll_poll_contacts; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY poll_poll_contacts (id, poll_id, contact_id) FROM stdin;
1	1	1
2	2	1
3	2	2
\.


--
-- Name: poll_poll_contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('poll_poll_contacts_id_seq', 3, true);


--
-- Name: poll_poll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('poll_poll_id_seq', 2, true);


--
-- Data for Name: poll_poll_messages; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY poll_poll_messages (id, poll_id, message_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	2	1
5	2	2
6	2	3
\.


--
-- Name: poll_poll_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('poll_poll_messages_id_seq', 6, true);


--
-- Data for Name: poll_poll_sites; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY poll_poll_sites (id, poll_id, site_id) FROM stdin;
1	1	2
2	2	1
\.


--
-- Name: poll_poll_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('poll_poll_sites_id_seq', 2, true);


--
-- Data for Name: poll_response; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY poll_response (id, message_id, poll_id, contact_id, date, has_errors) FROM stdin;
1	1	1	1	2013-10-24 15:46:02.056998+02	f
2	3	2	2	2013-10-24 15:48:47.624831+02	f
\.


--
-- Name: poll_response_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('poll_response_id_seq', 2, true);


--
-- Data for Name: poll_responsecategory; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY poll_responsecategory (id, category_id, response_id, is_override, user_id) FROM stdin;
1	1	1	t	1
2	2	2	f	3
\.


--
-- Name: poll_responsecategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('poll_responsecategory_id_seq', 2, true);


--
-- Data for Name: poll_rule; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY poll_rule (id, regex, category_id, rule_type, rule_string, rule) FROM stdin;
1	(\\brule\\ string1\\b)	1	c	rule string1	2
\.


--
-- Name: poll_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('poll_rule_id_seq', 1, true);


--
-- Data for Name: poll_translation; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY poll_translation (id, field, language, value) FROM stdin;
\.


--
-- Name: poll_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('poll_translation_id_seq', 1, false);


--
-- Data for Name: rapidsms_app; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_app (id, module, active) FROM stdin;
1	app1	f
2	app2	f
\.


--
-- Name: rapidsms_app_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_app_id_seq', 2, true);


--
-- Data for Name: rapidsms_backend; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_backend (id, name) FROM stdin;
1	console
2	backend1
3	backend2
\.


--
-- Name: rapidsms_backend_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_backend_id_seq', 3, true);


--
-- Data for Name: rapidsms_connection; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_connection (id, backend_id, identity, contact_id, created_on, modified_on) FROM stdin;
1	1	2067799294	\N	2013-10-17 15:31:53.644845+02	2013-10-17 15:31:53.644874+02
2	1	123	1	2013-10-24 15:27:53.015919+02	2013-10-24 15:27:53.01595+02
3	2	456	2	2013-10-24 15:29:53.009146+02	2013-10-24 15:29:53.009177+02
4	2	789	3	2013-10-25 09:12:38.328858+02	2013-10-25 09:12:38.32889+02
5	2	987	4	2013-10-25 09:23:17.053257+02	2013-10-25 09:23:17.053288+02
6	3	654	5	2013-10-25 09:30:06.664403+02	2013-10-25 09:30:06.664437+02
\.


--
-- Name: rapidsms_connection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_connection_id_seq', 6, true);


--
-- Data for Name: rapidsms_contact; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_contact (id, name, language, user_id, reporting_location_id, health_facility, is_caregiver, occupation, commune_id, active, birthdate, gender, colline_id, colline_name, created_on, modified_on) FROM stdin;
1	Contact1		1	\N	Croix rouge	t	occu	\N	t	2013-10-01 00:00:00+02	M	\N	coline name	2013-10-24 15:27:52.062674+02	2013-10-24 15:27:52.062704+02
2	Contact2		3	\N	health facility	t	occupation	\N	t	2013-10-01 00:00:00+02	F	\N	colline2	2013-10-24 15:29:44.950848+02	2013-10-24 15:29:44.950874+02
3	contact3		2	\N	health facility	t	occupation	\N	t	2012-10-01 09:04:57+02	M	\N	coline of contact3	2013-10-25 09:12:29.338352+02	2013-10-25 09:12:29.338384+02
4	contact4		\N	\N	health facility	t	occupation of contact4	\N	t	2013-10-01 09:15:17+02	F	\N	colline name of contact4	2013-10-25 09:23:16.808473+02	2013-10-25 09:23:16.808503+02
5	contact sans user		\N	\N	health facility	t	occupation of the contact without user	\N	t	2013-10-25 09:29:09+02	F	\N	colline name of contact of contact without user	2013-10-25 09:30:06.593647+02	2013-10-25 09:30:06.593698+02
\.


--
-- Data for Name: rapidsms_contact_groups; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_contact_groups (id, contact_id, group_id) FROM stdin;
1	1	2
2	2	3
3	3	1
4	3	2
5	3	3
6	4	1
7	4	2
8	4	3
9	5	1
10	5	2
11	5	3
\.


--
-- Name: rapidsms_contact_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_contact_groups_id_seq', 11, true);


--
-- Name: rapidsms_contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_contact_id_seq', 5, true);


--
-- Data for Name: rapidsms_contact_user_permissions; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_contact_user_permissions (id, contact_id, permission_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	1	5
6	1	6
7	1	7
8	1	8
9	1	9
10	1	10
11	1	11
12	1	12
13	1	270
14	1	271
15	1	272
16	1	273
17	1	274
18	1	275
19	1	20
20	1	21
21	1	278
22	1	279
23	1	70
24	1	71
25	1	72
26	1	76
27	1	77
28	1	78
29	1	79
30	1	80
31	1	81
32	1	82
33	1	83
34	1	84
35	1	85
36	1	86
37	1	87
38	1	19
39	1	276
40	1	277
41	2	1
42	2	2
43	2	3
44	2	4
45	2	5
46	2	6
47	2	7
48	2	8
49	2	9
50	2	10
51	2	11
52	2	12
53	2	13
54	2	14
55	2	15
56	2	16
57	2	17
58	2	18
59	2	19
60	2	20
61	2	21
62	2	22
63	2	23
64	2	24
65	2	25
66	2	26
67	2	27
68	2	28
69	2	29
70	2	30
71	2	31
72	2	32
73	2	33
74	2	34
75	2	35
76	2	36
77	2	37
78	2	38
79	2	39
80	2	40
81	2	41
82	2	42
83	2	43
84	2	44
85	2	45
86	2	46
87	2	47
88	2	48
89	2	49
90	2	50
91	2	51
92	2	52
93	2	53
94	2	54
95	2	55
96	2	56
97	2	57
98	2	58
99	2	59
100	2	60
101	2	61
102	2	62
103	2	63
104	2	64
105	2	65
106	2	66
107	2	67
108	2	68
109	2	69
110	2	70
111	2	71
112	2	72
113	2	73
114	2	74
115	2	75
116	2	76
117	2	77
118	2	78
119	2	79
120	2	80
121	2	81
122	2	82
123	2	83
124	2	84
125	2	85
126	2	86
127	2	87
128	2	88
129	2	89
130	2	90
131	2	91
132	2	92
133	2	93
134	2	94
135	2	95
136	2	96
137	2	97
138	2	98
139	2	99
140	2	100
141	2	101
142	2	102
143	2	103
144	2	104
145	2	105
146	2	106
147	2	107
148	2	108
149	2	109
150	2	110
151	2	111
152	2	112
153	2	113
154	2	114
155	2	115
156	2	116
157	2	117
158	2	118
159	2	119
160	2	120
161	2	121
162	2	122
163	2	123
164	2	124
165	2	125
166	2	126
167	2	127
168	2	128
169	2	129
170	2	130
171	2	131
172	2	132
173	2	133
174	2	134
175	2	135
176	2	136
177	2	137
178	2	138
179	2	139
180	2	140
181	2	141
182	2	142
183	2	143
184	2	144
185	2	145
186	2	146
187	2	147
188	2	148
189	2	149
190	2	150
191	2	151
192	2	152
193	2	153
194	2	154
195	2	155
196	2	156
197	2	157
198	2	158
199	2	159
200	2	160
201	2	161
202	2	162
203	2	163
204	2	164
205	2	165
206	2	166
207	2	167
208	2	168
209	2	169
210	2	170
211	2	171
212	2	172
213	2	173
214	2	174
215	2	175
216	2	176
217	2	177
218	2	178
219	2	179
220	2	180
221	2	181
222	2	182
223	2	183
224	2	184
225	2	185
226	2	186
227	2	187
228	2	188
229	2	189
230	2	190
231	2	191
232	2	192
233	2	193
234	2	194
235	2	195
236	2	196
237	2	197
238	2	198
239	2	199
240	2	200
241	2	201
242	2	202
243	2	203
244	2	204
245	2	205
246	2	206
247	2	207
248	2	208
249	2	209
250	2	210
251	2	211
252	2	212
253	2	213
254	2	214
255	2	215
256	2	216
257	2	217
258	2	218
259	2	219
260	2	220
261	2	221
262	2	222
263	2	223
264	2	224
265	2	225
266	2	226
267	2	227
268	2	228
269	2	229
270	2	230
271	2	231
272	2	232
273	2	233
274	2	234
275	2	235
276	2	236
277	2	237
278	2	238
279	2	239
280	2	240
281	2	241
282	2	242
283	2	243
284	2	244
285	2	245
286	2	246
287	2	247
288	2	248
289	2	249
290	2	250
291	2	251
292	2	252
293	2	253
294	2	254
295	2	255
296	2	256
297	2	257
298	2	258
299	2	259
300	2	260
301	2	261
302	2	262
303	2	263
304	2	264
305	2	265
306	2	266
307	2	267
308	2	268
309	2	269
310	2	270
311	2	271
312	2	272
313	2	273
314	2	274
315	2	275
316	2	276
317	2	277
318	2	278
319	2	279
320	2	280
321	2	281
322	2	282
323	2	283
324	2	284
325	2	285
326	2	286
327	2	287
328	2	288
329	2	289
330	2	290
331	2	291
332	2	292
333	2	293
334	2	294
335	2	295
336	2	296
337	2	297
338	2	298
339	2	299
340	2	300
341	2	301
342	2	302
343	2	303
344	3	1
345	3	2
346	3	3
347	3	4
348	3	5
349	3	6
350	3	7
351	3	8
352	3	9
353	3	10
354	3	11
355	3	12
356	3	13
357	3	14
358	3	15
359	3	16
360	3	17
361	3	18
362	3	19
363	3	20
364	3	21
365	3	22
366	3	23
367	3	24
368	3	25
369	3	26
370	3	27
371	3	28
372	3	29
373	3	30
374	3	31
375	3	32
376	3	33
377	3	34
378	3	35
379	3	36
380	3	37
381	3	38
382	3	39
383	3	40
384	3	41
385	3	42
386	3	43
387	3	44
388	3	45
389	3	46
390	3	47
391	3	48
392	3	49
393	3	50
394	3	51
395	3	52
396	3	53
397	3	54
398	3	55
399	3	56
400	3	57
401	3	58
402	3	59
403	3	60
404	3	61
405	3	62
406	3	63
407	3	64
408	3	65
409	3	66
410	3	67
411	3	68
412	3	69
413	3	70
414	3	71
415	3	72
416	3	73
417	3	74
418	3	75
419	3	76
420	3	77
421	3	78
422	3	79
423	3	80
424	3	81
425	3	82
426	3	83
427	3	84
428	3	85
429	3	86
430	3	87
431	3	88
432	3	89
433	3	90
434	3	91
435	3	92
436	3	93
437	3	94
438	3	95
439	3	96
440	3	97
441	3	98
442	3	99
443	3	100
444	3	101
445	3	102
446	3	103
447	3	104
448	3	105
449	3	106
450	3	107
451	3	108
452	3	109
453	3	110
454	3	111
455	3	112
456	3	113
457	3	114
458	3	115
459	3	116
460	3	117
461	3	118
462	3	119
463	3	120
464	3	121
465	3	122
466	3	123
467	3	124
468	3	125
469	3	126
470	3	127
471	3	128
472	3	129
473	3	130
474	3	131
475	3	132
476	3	133
477	3	134
478	3	135
479	3	136
480	3	137
481	3	138
482	3	139
483	3	140
484	3	141
485	3	142
486	3	143
487	3	144
488	3	145
489	3	146
490	3	147
491	3	148
492	3	149
493	3	150
494	3	151
495	3	152
496	3	153
497	3	154
498	3	155
499	3	156
500	3	157
501	3	158
502	3	159
503	3	160
504	3	161
505	3	162
506	3	163
507	3	164
508	3	165
509	3	166
510	3	167
511	3	168
512	3	169
513	3	170
514	3	171
515	3	172
516	3	173
517	3	174
518	3	175
519	3	176
520	3	177
521	3	178
522	3	179
523	3	180
524	3	181
525	3	182
526	3	183
527	3	184
528	3	185
529	3	186
530	3	187
531	3	188
532	3	189
533	3	190
534	3	191
535	3	192
536	3	193
537	3	194
538	3	195
539	3	196
540	3	197
541	3	198
542	3	199
543	3	200
544	3	201
545	3	202
546	3	203
547	3	204
548	3	205
549	3	206
550	3	207
551	3	208
552	3	209
553	3	210
554	3	211
555	3	212
556	3	213
557	3	214
558	3	215
559	3	216
560	3	217
561	3	218
562	3	219
563	3	220
564	3	221
565	3	222
566	3	223
567	3	224
568	3	225
569	3	226
570	3	227
571	3	228
572	3	229
573	3	230
574	3	231
575	3	232
576	3	233
577	3	234
578	3	235
579	3	236
580	3	237
581	3	238
582	3	239
583	3	240
584	3	241
585	3	242
586	3	243
587	3	244
588	3	245
589	3	246
590	3	247
591	3	248
592	3	249
593	3	250
594	3	251
595	3	252
596	3	253
597	3	254
598	3	255
599	3	256
600	3	257
601	3	258
602	3	259
603	3	260
604	3	261
605	3	262
606	3	263
607	3	264
608	3	265
609	3	266
610	3	267
611	3	268
612	3	269
613	3	270
614	3	271
615	3	272
616	3	273
617	3	274
618	3	275
619	3	276
620	3	277
621	3	278
622	3	279
623	3	280
624	3	281
625	3	282
626	3	283
627	3	284
628	3	285
629	3	286
630	3	287
631	3	288
632	3	289
633	3	290
634	3	291
635	3	292
636	3	293
637	3	294
638	3	295
639	3	296
640	3	297
641	3	298
642	3	299
643	3	300
644	3	301
645	3	302
646	3	303
647	4	1
648	4	2
649	4	3
650	4	4
651	4	5
652	4	6
653	4	7
654	4	8
655	4	9
656	4	10
657	4	11
658	4	12
659	4	13
660	4	14
661	4	15
662	4	16
663	4	17
664	4	18
665	4	19
666	4	20
667	4	21
668	4	22
669	4	23
670	4	24
671	4	25
672	4	26
673	4	27
674	4	28
675	4	29
676	4	30
677	4	31
678	4	32
679	4	33
680	4	34
681	4	35
682	4	36
683	4	37
684	4	38
685	4	39
686	4	40
687	4	41
688	4	42
689	4	43
690	4	44
691	4	45
692	4	46
693	4	47
694	4	48
695	4	49
696	4	50
697	4	51
698	4	52
699	4	53
700	4	54
701	4	55
702	4	56
703	4	57
704	4	58
705	4	59
706	4	60
707	4	61
708	4	62
709	4	63
710	4	64
711	4	65
712	4	66
713	4	67
714	4	68
715	4	69
716	4	70
717	4	71
718	4	72
719	4	73
720	4	74
721	4	75
722	4	76
723	4	77
724	4	78
725	4	79
726	4	80
727	4	81
728	4	82
729	4	83
730	4	84
731	4	85
732	4	86
733	4	87
734	4	88
735	4	89
736	4	90
737	4	91
738	4	92
739	4	93
740	4	94
741	4	95
742	4	96
743	4	97
744	4	98
745	4	99
746	4	100
747	4	101
748	4	102
749	4	103
750	4	104
751	4	105
752	4	106
753	4	107
754	4	108
755	4	109
756	4	110
757	4	111
758	4	112
759	4	113
760	4	114
761	4	115
762	4	116
763	4	117
764	4	118
765	4	119
766	4	120
767	4	121
768	4	122
769	4	123
770	4	124
771	4	125
772	4	126
773	4	127
774	4	128
775	4	129
776	4	130
777	4	131
778	4	132
779	4	133
780	4	134
781	4	135
782	4	136
783	4	137
784	4	138
785	4	139
786	4	140
787	4	141
788	4	142
789	4	143
790	4	144
791	4	145
792	4	146
793	4	147
794	4	148
795	4	149
796	4	150
797	4	151
798	4	152
799	4	153
800	4	154
801	4	155
802	4	156
803	4	157
804	4	158
805	4	159
806	4	160
807	4	161
808	4	162
809	4	163
810	4	164
811	4	165
812	4	166
813	4	167
814	4	168
815	4	169
816	4	170
817	4	171
818	4	172
819	4	173
820	4	174
821	4	175
822	4	176
823	4	177
824	4	178
825	4	179
826	4	180
827	4	181
828	4	182
829	4	183
830	4	184
831	4	185
832	4	186
833	4	187
834	4	188
835	4	189
836	4	190
837	4	191
838	4	192
839	4	193
840	4	194
841	4	195
842	4	196
843	4	197
844	4	198
845	4	199
846	4	200
847	4	201
848	4	202
849	4	203
850	4	204
851	4	205
852	4	206
853	4	207
854	4	208
855	4	209
856	4	210
857	4	211
858	4	212
859	4	213
860	4	214
861	4	215
862	4	216
863	4	217
864	4	218
865	4	219
866	4	220
867	4	221
868	4	222
869	4	223
870	4	224
871	4	225
872	4	226
873	4	227
874	4	228
875	4	229
876	4	230
877	4	231
878	4	232
879	4	233
880	4	234
881	4	235
882	4	236
883	4	237
884	4	238
885	4	239
886	4	240
887	4	241
888	4	242
889	4	243
890	4	244
891	4	245
892	4	246
893	4	247
894	4	248
895	4	249
896	4	250
897	4	251
898	4	252
899	4	253
900	4	254
901	4	255
902	4	256
903	4	257
904	4	258
905	4	259
906	4	260
907	4	261
908	4	262
909	4	263
910	4	264
911	4	265
912	4	266
913	4	267
914	4	268
915	4	269
916	4	270
917	4	271
918	4	272
919	4	273
920	4	274
921	4	275
922	4	276
923	4	277
924	4	278
925	4	279
926	4	280
927	4	281
928	4	282
929	4	283
930	4	284
931	4	285
932	4	286
933	4	287
934	4	288
935	4	289
936	4	290
937	4	291
938	4	292
939	4	293
940	4	294
941	4	295
942	4	296
943	4	297
944	4	298
945	4	299
946	4	300
947	4	301
948	4	302
949	4	303
950	5	1
951	5	2
952	5	3
953	5	4
954	5	5
955	5	6
956	5	7
957	5	8
958	5	9
959	5	10
960	5	11
961	5	12
962	5	13
963	5	14
964	5	15
965	5	16
966	5	17
967	5	18
968	5	19
969	5	20
970	5	21
971	5	22
972	5	23
973	5	24
974	5	25
975	5	26
976	5	27
977	5	28
978	5	29
979	5	30
980	5	31
981	5	32
982	5	33
983	5	34
984	5	35
985	5	36
986	5	37
987	5	38
988	5	39
989	5	40
990	5	41
991	5	42
992	5	43
993	5	44
994	5	45
995	5	46
996	5	47
997	5	48
998	5	49
999	5	50
1000	5	51
1001	5	52
1002	5	53
1003	5	54
1004	5	55
1005	5	56
1006	5	57
1007	5	58
1008	5	59
1009	5	60
1010	5	61
1011	5	62
1012	5	63
1013	5	64
1014	5	65
1015	5	66
1016	5	67
1017	5	68
1018	5	69
1019	5	70
1020	5	71
1021	5	72
1022	5	73
1023	5	74
1024	5	75
1025	5	76
1026	5	77
1027	5	78
1028	5	79
1029	5	80
1030	5	81
1031	5	82
1032	5	83
1033	5	84
1034	5	85
1035	5	86
1036	5	87
1037	5	88
1038	5	89
1039	5	90
1040	5	91
1041	5	92
1042	5	93
1043	5	94
1044	5	95
1045	5	96
1046	5	97
1047	5	98
1048	5	99
1049	5	100
1050	5	101
1051	5	102
1052	5	103
1053	5	104
1054	5	105
1055	5	106
1056	5	107
1057	5	108
1058	5	109
1059	5	110
1060	5	111
1061	5	112
1062	5	113
1063	5	114
1064	5	115
1065	5	116
1066	5	117
1067	5	118
1068	5	119
1069	5	120
1070	5	121
1071	5	122
1072	5	123
1073	5	124
1074	5	125
1075	5	126
1076	5	127
1077	5	128
1078	5	129
1079	5	130
1080	5	131
1081	5	132
1082	5	133
1083	5	134
1084	5	135
1085	5	136
1086	5	137
1087	5	138
1088	5	139
1089	5	140
1090	5	141
1091	5	142
1092	5	143
1093	5	144
1094	5	145
1095	5	146
1096	5	147
1097	5	148
1098	5	149
1099	5	150
1100	5	151
1101	5	152
1102	5	153
1103	5	154
1104	5	155
1105	5	156
1106	5	157
1107	5	158
1108	5	159
1109	5	160
1110	5	161
1111	5	162
1112	5	163
1113	5	164
1114	5	165
1115	5	166
1116	5	167
1117	5	168
1118	5	169
1119	5	170
1120	5	171
1121	5	172
1122	5	173
1123	5	174
1124	5	175
1125	5	176
1126	5	177
1127	5	178
1128	5	179
1129	5	180
1130	5	181
1131	5	182
1132	5	183
1133	5	184
1134	5	185
1135	5	186
1136	5	187
1137	5	188
1138	5	189
1139	5	190
1140	5	191
1141	5	192
1142	5	193
1143	5	194
1144	5	195
1145	5	196
1146	5	197
1147	5	198
1148	5	199
1149	5	200
1150	5	201
1151	5	202
1152	5	203
1153	5	204
1154	5	205
1155	5	206
1156	5	207
1157	5	208
1158	5	209
1159	5	210
1160	5	211
1161	5	212
1162	5	213
1163	5	214
1164	5	215
1165	5	216
1166	5	217
1167	5	218
1168	5	219
1169	5	220
1170	5	221
1171	5	222
1172	5	223
1173	5	224
1174	5	225
1175	5	226
1176	5	227
1177	5	228
1178	5	229
1179	5	230
1180	5	231
1181	5	232
1182	5	233
1183	5	234
1184	5	235
1185	5	236
1186	5	237
1187	5	238
1188	5	239
1189	5	240
1190	5	241
1191	5	242
1192	5	243
1193	5	244
1194	5	245
1195	5	246
1196	5	247
1197	5	248
1198	5	249
1199	5	250
1200	5	251
1201	5	252
1202	5	253
1203	5	254
1204	5	255
1205	5	256
1206	5	257
1207	5	258
1208	5	259
1209	5	260
1210	5	261
1211	5	262
1212	5	263
1213	5	264
1214	5	265
1215	5	266
1216	5	267
1217	5	268
1218	5	269
1219	5	270
1220	5	271
1221	5	272
1222	5	273
1223	5	274
1224	5	275
1225	5	276
1226	5	277
1227	5	278
1228	5	279
1229	5	280
1230	5	281
1231	5	282
1232	5	283
1233	5	284
1234	5	285
1235	5	286
1236	5	287
1237	5	288
1238	5	289
1239	5	290
1240	5	291
1241	5	292
1242	5	293
1243	5	294
1244	5	295
1245	5	296
1246	5	297
1247	5	298
1248	5	299
1249	5	300
1250	5	301
1251	5	302
1252	5	303
\.


--
-- Name: rapidsms_contact_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_contact_user_permissions_id_seq', 1252, true);


--
-- Data for Name: rapidsms_httprouter_deliveryerror; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_httprouter_deliveryerror (id, message_id, log, created_on) FROM stdin;
\.


--
-- Name: rapidsms_httprouter_deliveryerror_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_httprouter_deliveryerror_id_seq', 1, false);


--
-- Data for Name: rapidsms_httprouter_message; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_httprouter_message (id, connection_id, text, direction, status, date, in_response_to_id, updated, sent, delivered, batch_id, priority, application) FROM stdin;
1	1	Bonjour	I	H	2013-10-17 15:31:53.69184+02	\N	2013-10-17 15:31:53.979966+02	\N	\N	\N	10	\N
2	1	Bonjour	I	H	2013-10-17 15:34:03.95129+02	\N	2013-10-17 15:34:04.000361+02	\N	\N	\N	10	\N
3	1	Bite?	I	H	2013-10-17 15:34:40.263138+02	\N	2013-10-17 15:34:40.297494+02	\N	\N	\N	10	\N
\.


--
-- Name: rapidsms_httprouter_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_httprouter_message_id_seq', 3, true);


--
-- Data for Name: rapidsms_httprouter_messagebatch; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_httprouter_messagebatch (id, status, name) FROM stdin;
\.


--
-- Name: rapidsms_httprouter_messagebatch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_httprouter_messagebatch_id_seq', 1, false);


--
-- Data for Name: rapidsms_xforms_binaryvalue; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_binaryvalue (id, "binary") FROM stdin;
\.


--
-- Name: rapidsms_xforms_binaryvalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_xforms_binaryvalue_id_seq', 1, false);


--
-- Data for Name: rapidsms_xforms_xform; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_xform (id, name, keyword, description, response, active, command_prefix, keyword_prefix, separator, restrict_message, owner_id, created, modified, site_id) FROM stdin;
\.


--
-- Name: rapidsms_xforms_xform_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_xforms_xform_id_seq', 1, false);


--
-- Data for Name: rapidsms_xforms_xform_restrict_to; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_xform_restrict_to (id, xform_id, group_id) FROM stdin;
\.


--
-- Name: rapidsms_xforms_xform_restrict_to_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_xforms_xform_restrict_to_id_seq', 1, false);


--
-- Data for Name: rapidsms_xforms_xformfield; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_xformfield (attribute_ptr_id, xform_id, field_type, command, "order", question) FROM stdin;
\.


--
-- Data for Name: rapidsms_xforms_xformfieldconstraint; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_xformfieldconstraint (id, field_id, type, test, message, "order") FROM stdin;
\.


--
-- Name: rapidsms_xforms_xformfieldconstraint_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_xforms_xformfieldconstraint_id_seq', 1, false);


--
-- Data for Name: rapidsms_xforms_xformlist; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_xformlist (id, xform_id, report_id, required, priority) FROM stdin;
\.


--
-- Name: rapidsms_xforms_xformlist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_xforms_xformlist_id_seq', 1, false);


--
-- Data for Name: rapidsms_xforms_xformreport; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_xformreport (id, name, frequency, constraints) FROM stdin;
\.


--
-- Name: rapidsms_xforms_xformreport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_xforms_xformreport_id_seq', 1, false);


--
-- Data for Name: rapidsms_xforms_xformreportsubmission; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_xformreportsubmission (id, report_id, start_date, status, created) FROM stdin;
\.


--
-- Name: rapidsms_xforms_xformreportsubmission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_xforms_xformreportsubmission_id_seq', 1, false);


--
-- Data for Name: rapidsms_xforms_xformreportsubmission_submissions; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_xformreportsubmission_submissions (id, xformreportsubmission_id, xformsubmission_id) FROM stdin;
\.


--
-- Name: rapidsms_xforms_xformreportsubmission_submissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_xforms_xformreportsubmission_submissions_id_seq', 1, false);


--
-- Data for Name: rapidsms_xforms_xformsubmission; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_xformsubmission (id, xform_id, type, connection_id, raw, has_errors, approved, created, confirmation_id, message_id) FROM stdin;
\.


--
-- Name: rapidsms_xforms_xformsubmission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('rapidsms_xforms_xformsubmission_id_seq', 1, false);


--
-- Data for Name: rapidsms_xforms_xformsubmissionvalue; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY rapidsms_xforms_xformsubmissionvalue (value_ptr_id, submission_id) FROM stdin;
\.


--
-- Data for Name: script_email; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY script_email (id, subject, sender, message) FROM stdin;
\.


--
-- Name: script_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('script_email_id_seq', 1, false);


--
-- Data for Name: script_email_recipients; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY script_email_recipients (id, email_id, user_id) FROM stdin;
\.


--
-- Name: script_email_recipients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('script_email_recipients_id_seq', 1, false);


--
-- Data for Name: script_script; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY script_script (slug, name, enabled) FROM stdin;
\.


--
-- Data for Name: script_script_sites; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY script_script_sites (id, script_id, site_id) FROM stdin;
\.


--
-- Name: script_script_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('script_script_sites_id_seq', 1, false);


--
-- Data for Name: script_scriptprogress; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY script_scriptprogress (id, connection_id, script_id, step_id, status, "time", num_tries, language) FROM stdin;
\.


--
-- Name: script_scriptprogress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('script_scriptprogress_id_seq', 1, false);


--
-- Data for Name: script_scriptresponse; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY script_scriptresponse (id, session_id, response_id) FROM stdin;
\.


--
-- Name: script_scriptresponse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('script_scriptresponse_id_seq', 1, false);


--
-- Data for Name: script_scriptsession; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY script_scriptsession (id, connection_id, script_id, start_time, end_time) FROM stdin;
\.


--
-- Name: script_scriptsession_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('script_scriptsession_id_seq', 1, false);


--
-- Data for Name: script_scriptstep; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY script_scriptstep (id, script_id, poll_id, message, email_id, "order", rule, start_offset, retry_offset, giveup_offset, num_tries) FROM stdin;
\.


--
-- Name: script_scriptstep_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('script_scriptstep_id_seq', 1, false);


--
-- Data for Name: south_migrationhistory; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY south_migrationhistory (id, app_name, migration, applied) FROM stdin;
1	django_extensions	0001_empty	2013-08-02 13:05:47.073396+02
2	djcelery	0001_initial	2013-08-02 13:05:48.129311+02
3	djcelery	0002_v25_changes	2013-08-02 13:05:48.949149+02
4	djcelery	0003_v26_changes	2013-08-02 13:05:49.101484+02
5	djcelery	0004_v30_changes	2013-08-02 13:05:49.135389+02
6	tastypie	0001_initial	2013-08-02 13:05:49.512478+02
7	tastypie	0002_add_apikey_index	2013-08-02 13:05:49.576814+02
8	rapidsms_httprouter	0001_initial	2013-08-02 13:05:49.837996+02
9	rapidsms_httprouter	0002_auto__add_field_message_updated	2013-08-02 13:05:49.857837+02
10	rapidsms_httprouter	0003_auto__add_deliveryerror__add_field_message_sent__add_field_message_del	2013-08-02 13:05:50.005041+02
11	rapidsms_httprouter	0004_auto__add_messagebatch__add_field_message_batch__add_field_message_pri	2013-08-02 13:05:50.306955+02
12	rapidsms_httprouter	0005_auto__add_field_message_application	2013-08-02 13:05:50.356573+02
13	poll	0001_initial	2013-08-02 13:05:51.837323+02
14	ureport	0001_initial	2013-08-02 13:05:53.258413+02
15	ureport	0002_create_contact_export_view	2013-08-02 13:05:53.578077+02
16	ureport	0026_auto__add_field_autoreggrouprules_rule__add_field_autoreggrouprules_cl	2013-08-02 13:05:53.888328+02
17	ureport	0028_alter_occupation_contact	2013-08-02 13:05:54.270315+02
18	ureport	0029_auto__add_pollattribute__add_unique_pollattribute_poll_key__add_unique	2013-08-02 13:05:54.53042+02
19	ureport	0030_auto__add_pollattributevalue__del_field_pollattribute_key_default__del	2013-08-02 13:05:55.217463+02
20	ureport	0031_add_timestamps_to_contact_and_connection	2013-08-02 13:05:55.30624+02
21	ureport	0032_add_senttomtrac	2013-08-02 13:05:55.582641+02
22	script	0001_initial	2013-08-02 13:05:57.142812+02
23	rapidsms_xforms	0001_initial	2013-08-02 13:05:59.037818+02
24	generic	0001_initial	2013-08-02 13:05:59.507728+02
25	ussd	0001_initial	2013-08-02 13:06:00.716311+02
26	uganda_common	0001_initial	2013-08-02 13:06:01.270739+02
27	uganda_common	0002_auto__add_unique_accessurls_url	2013-08-02 13:06:01.522078+02
28	contact	0001_initial	2013-08-02 13:06:02.261606+02
29	geoserver	0001_initial	2013-08-02 13:06:02.842+02
30	message_classifier	0001_initial	2013-08-02 13:06:03.43695+02
\.


--
-- Name: south_migrationhistory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('south_migrationhistory_id_seq', 30, true);


--
-- Data for Name: tastypie_apiaccess; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY tastypie_apiaccess (id, identifier, url, request_method, accessed) FROM stdin;
\.


--
-- Name: tastypie_apiaccess_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('tastypie_apiaccess_id_seq', 1, false);


--
-- Data for Name: tastypie_apikey; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY tastypie_apikey (id, user_id, key, created) FROM stdin;
\.


--
-- Name: tastypie_apikey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('tastypie_apikey_id_seq', 1, false);


--
-- Data for Name: uganda_common_access; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY uganda_common_access (id, user_id) FROM stdin;
\.


--
-- Data for Name: uganda_common_access_allowed_locations; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY uganda_common_access_allowed_locations (id, access_id, location_id) FROM stdin;
\.


--
-- Name: uganda_common_access_allowed_locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('uganda_common_access_allowed_locations_id_seq', 1, false);


--
-- Data for Name: uganda_common_access_allowed_urls; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY uganda_common_access_allowed_urls (id, access_id, accessurls_id) FROM stdin;
\.


--
-- Name: uganda_common_access_allowed_urls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('uganda_common_access_allowed_urls_id_seq', 1, false);


--
-- Data for Name: uganda_common_access_groups; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY uganda_common_access_groups (id, access_id, group_id) FROM stdin;
\.


--
-- Name: uganda_common_access_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('uganda_common_access_groups_id_seq', 1, false);


--
-- Name: uganda_common_access_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('uganda_common_access_id_seq', 1, false);


--
-- Data for Name: uganda_common_accessurls; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY uganda_common_accessurls (id, url) FROM stdin;
\.


--
-- Name: uganda_common_accessurls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('uganda_common_accessurls_id_seq', 1, false);


--
-- Data for Name: unregister_blacklist; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY unregister_blacklist (id, connection_id) FROM stdin;
\.


--
-- Name: unregister_blacklist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('unregister_blacklist_id_seq', 1, false);


--
-- Data for Name: ureport_autoreggrouprules; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_autoreggrouprules (id, group_id, "values", rule, closed, rule_regex) FROM stdin;
\.


--
-- Name: ureport_autoreggrouprules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_autoreggrouprules_id_seq', 1, false);


--
-- Data for Name: ureport_contact; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_contact (id, name, is_caregiver, reporting_location_id, user_id, mobile, language, province, age, gender, facility, colline, responses, questions, incoming, connection_pk, "group", dirty, expiry) FROM stdin;
1	Contact1	t	\N	1	\N		\N	23 days	M	Croix rouge	\N	0	\N	0	\N	\N	\N	\N
2	Contact2	t	\N	3	\N		\N	23 days	F	health facility	\N	0	\N	0	\N	\N	\N	\N
3	contact3	t	\N	2	\N		\N	1 year 23 days 14:55:03	M	health facility	\N	0	\N	0	\N	\N	\N	\N
4	contact4	t	\N	\N	\N		\N	23 days 14:44:43	F	health facility	\N	0	\N	0	\N	\N	\N	\N
5	contact sans user	t	\N	\N	\N		\N	-09:29:09	F	health facility	\N	0	\N	0	\N	\N	\N	\N
\.


--
-- Data for Name: ureport_equatellocation; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_equatellocation (id, serial, segment, location_id, name) FROM stdin;
\.


--
-- Name: ureport_equatellocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_equatellocation_id_seq', 1, false);


--
-- Data for Name: ureport_ignoredtags; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_ignoredtags (id, poll_id, name) FROM stdin;
\.


--
-- Name: ureport_ignoredtags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_ignoredtags_id_seq', 1, false);


--
-- Data for Name: ureport_messageattribute; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_messageattribute (id, name, description) FROM stdin;
\.


--
-- Name: ureport_messageattribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_messageattribute_id_seq', 1, false);


--
-- Data for Name: ureport_messagedetail; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_messagedetail (id, message_id, attribute_id, value, description) FROM stdin;
\.


--
-- Name: ureport_messagedetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_messagedetail_id_seq', 1, false);


--
-- Data for Name: ureport_permit; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_permit (id, user_id, allowed, date) FROM stdin;
\.


--
-- Name: ureport_permit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_permit_id_seq', 1, false);


--
-- Data for Name: ureport_pollattribute; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_pollattribute (id, key, key_type, "default") FROM stdin;
\.


--
-- Name: ureport_pollattribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_pollattribute_id_seq', 1, false);


--
-- Data for Name: ureport_pollattribute_values; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_pollattribute_values (id, pollattribute_id, pollattributevalue_id) FROM stdin;
\.


--
-- Name: ureport_pollattribute_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_pollattribute_values_id_seq', 1, false);


--
-- Data for Name: ureport_pollattributevalue; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_pollattributevalue (id, value, poll_id) FROM stdin;
\.


--
-- Name: ureport_pollattributevalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_pollattributevalue_id_seq', 1, false);


--
-- Data for Name: ureport_quotebox; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_quotebox (id, question, quote, quoted, creation_date) FROM stdin;
1	quote box question	quote box quote	quote box quoted	2013-10-24 15:35:12.680235+02
2	quote box question1	quote box quote1	quote box quoted1	2013-10-24 15:36:07.07282+02
\.


--
-- Name: ureport_quotebox_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_quotebox_id_seq', 2, true);


--
-- Data for Name: ureport_senttomtrac; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_senttomtrac (id, message_id, sent_on) FROM stdin;
\.


--
-- Name: ureport_senttomtrac_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_senttomtrac_id_seq', 1, false);


--
-- Data for Name: ureport_settings; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_settings (id, attribute, value, description, user_id) FROM stdin;
\.


--
-- Name: ureport_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_settings_id_seq', 1, false);


--
-- Data for Name: ureport_topresponses; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ureport_topresponses (id, poll_id, quote, quoted) FROM stdin;
\.


--
-- Name: ureport_topresponses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ureport_topresponses_id_seq', 1, false);


--
-- Data for Name: ussd_field; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ussd_field (question_ptr_id, field_id) FROM stdin;
\.


--
-- Data for Name: ussd_menu; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ussd_menu (screen_ptr_id) FROM stdin;
\.


--
-- Data for Name: ussd_navigation; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ussd_navigation (id, screen_id, text, response, date, session_id) FROM stdin;
\.


--
-- Name: ussd_navigation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ussd_navigation_id_seq', 1, false);


--
-- Data for Name: ussd_question; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ussd_question (screen_ptr_id, question_text, next_id) FROM stdin;
\.


--
-- Data for Name: ussd_screen; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ussd_screen (slug, label, "order", parent_id, lft, rght, tree_id, level) FROM stdin;
\.


--
-- Data for Name: ussd_session; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ussd_session (id, transaction_id, connection_id) FROM stdin;
\.


--
-- Name: ussd_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ussd_session_id_seq', 1, false);


--
-- Data for Name: ussd_session_submissions; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ussd_session_submissions (id, session_id, xformsubmission_id) FROM stdin;
\.


--
-- Name: ussd_session_submissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helpdeskadmin
--

SELECT pg_catalog.setval('ussd_session_submissions_id_seq', 1, false);


--
-- Data for Name: ussd_stubscreen; Type: TABLE DATA; Schema: public; Owner: helpdeskadmin
--

COPY ussd_stubscreen (screen_ptr_id, terminal, text) FROM stdin;
\.


--
-- Name: alerts_export_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY alerts_export
    ADD CONSTRAINT alerts_export_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: celery_taskmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_pkey PRIMARY KEY (id);


--
-- Name: celery_taskmeta_task_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_task_id_key UNIQUE (task_id);


--
-- Name: celery_tasksetmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_pkey PRIMARY KEY (id);


--
-- Name: celery_tasksetmeta_taskset_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_taskset_id_key UNIQUE (taskset_id);


--
-- Name: contact_flag_name_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY contact_flag
    ADD CONSTRAINT contact_flag_name_key UNIQUE (name);


--
-- Name: contact_flag_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY contact_flag
    ADD CONSTRAINT contact_flag_pkey PRIMARY KEY (id);


--
-- Name: contact_masstext_contacts_masstext_id_7ba66255_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY contact_masstext_contacts
    ADD CONSTRAINT contact_masstext_contacts_masstext_id_7ba66255_uniq UNIQUE (masstext_id, contact_id);


--
-- Name: contact_masstext_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY contact_masstext_contacts
    ADD CONSTRAINT contact_masstext_contacts_pkey PRIMARY KEY (id);


--
-- Name: contact_masstext_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY contact_masstext
    ADD CONSTRAINT contact_masstext_pkey PRIMARY KEY (id);


--
-- Name: contact_masstext_sites_masstext_id_301d93d7_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY contact_masstext_sites
    ADD CONSTRAINT contact_masstext_sites_masstext_id_301d93d7_uniq UNIQUE (masstext_id, site_id);


--
-- Name: contact_masstext_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY contact_masstext_sites
    ADD CONSTRAINT contact_masstext_sites_pkey PRIMARY KEY (id);


--
-- Name: contact_messageflag_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY contact_messageflag
    ADD CONSTRAINT contact_messageflag_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_model_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_key UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: djcelery_crontabschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY djcelery_crontabschedule
    ADD CONSTRAINT djcelery_crontabschedule_pkey PRIMARY KEY (id);


--
-- Name: djcelery_intervalschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY djcelery_intervalschedule
    ADD CONSTRAINT djcelery_intervalschedule_pkey PRIMARY KEY (id);


--
-- Name: djcelery_periodictask_name_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_name_key UNIQUE (name);


--
-- Name: djcelery_periodictask_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_pkey PRIMARY KEY (id);


--
-- Name: djcelery_periodictasks_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY djcelery_periodictasks
    ADD CONSTRAINT djcelery_periodictasks_pkey PRIMARY KEY (ident);


--
-- Name: djcelery_taskstate_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_pkey PRIMARY KEY (id);


--
-- Name: djcelery_taskstate_task_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_task_id_key UNIQUE (task_id);


--
-- Name: djcelery_workerstate_hostname_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_hostname_key UNIQUE (hostname);


--
-- Name: djcelery_workerstate_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_pkey PRIMARY KEY (id);


--
-- Name: eav_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_attribute
    ADD CONSTRAINT eav_attribute_pkey PRIMARY KEY (id);


--
-- Name: eav_attribute_site_id_slug_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_attribute
    ADD CONSTRAINT eav_attribute_site_id_slug_key UNIQUE (site_id, slug);


--
-- Name: eav_encounter_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_encounter
    ADD CONSTRAINT eav_encounter_pkey PRIMARY KEY (id);


--
-- Name: eav_enumgroup_enums_enumgroup_id_enumvalue_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_enumgroup_enums
    ADD CONSTRAINT eav_enumgroup_enums_enumgroup_id_enumvalue_id_key UNIQUE (enumgroup_id, enumvalue_id);


--
-- Name: eav_enumgroup_enums_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_enumgroup_enums
    ADD CONSTRAINT eav_enumgroup_enums_pkey PRIMARY KEY (id);


--
-- Name: eav_enumgroup_name_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_enumgroup
    ADD CONSTRAINT eav_enumgroup_name_key UNIQUE (name);


--
-- Name: eav_enumgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_enumgroup
    ADD CONSTRAINT eav_enumgroup_pkey PRIMARY KEY (id);


--
-- Name: eav_enumvalue_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_enumvalue
    ADD CONSTRAINT eav_enumvalue_pkey PRIMARY KEY (id);


--
-- Name: eav_enumvalue_value_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_enumvalue
    ADD CONSTRAINT eav_enumvalue_value_key UNIQUE (value);


--
-- Name: eav_patient_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_patient
    ADD CONSTRAINT eav_patient_pkey PRIMARY KEY (id);


--
-- Name: eav_value_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY eav_value
    ADD CONSTRAINT eav_value_pkey PRIMARY KEY (id);


--
-- Name: generic_dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY generic_dashboard
    ADD CONSTRAINT generic_dashboard_pkey PRIMARY KEY (id);


--
-- Name: generic_module_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY generic_module
    ADD CONSTRAINT generic_module_pkey PRIMARY KEY (id);


--
-- Name: generic_moduleparams_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY generic_moduleparams
    ADD CONSTRAINT generic_moduleparams_pkey PRIMARY KEY (id);


--
-- Name: generic_staticmodulecontent_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY generic_staticmodulecontent
    ADD CONSTRAINT generic_staticmodulecontent_pkey PRIMARY KEY (id);


--
-- Name: geoserver_basicclasslayer_deployment_id_10cb939_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY geoserver_basicclasslayer
    ADD CONSTRAINT geoserver_basicclasslayer_deployment_id_10cb939_uniq UNIQUE (deployment_id, layer_id, district);


--
-- Name: geoserver_basicclasslayer_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY geoserver_basicclasslayer
    ADD CONSTRAINT geoserver_basicclasslayer_pkey PRIMARY KEY (id);


--
-- Name: geoserver_emisattendencedata_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY geoserver_emisattendencedata
    ADD CONSTRAINT geoserver_emisattendencedata_pkey PRIMARY KEY (id);


--
-- Name: geoserver_pollcategorydata_deployment_id_79854ef_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY geoserver_pollcategorydata
    ADD CONSTRAINT geoserver_pollcategorydata_deployment_id_79854ef_uniq UNIQUE (deployment_id, poll_id, district);


--
-- Name: geoserver_pollcategorydata_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY geoserver_pollcategorydata
    ADD CONSTRAINT geoserver_pollcategorydata_pkey PRIMARY KEY (id);


--
-- Name: geoserver_polldata_deployment_id_4b2b5c31_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY geoserver_polldata
    ADD CONSTRAINT geoserver_polldata_deployment_id_4b2b5c31_uniq UNIQUE (deployment_id, poll_id, district);


--
-- Name: geoserver_polldata_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY geoserver_polldata
    ADD CONSTRAINT geoserver_polldata_pkey PRIMARY KEY (id);


--
-- Name: geoserver_pollresponsedata_deployment_id_10ade48c_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY geoserver_pollresponsedata
    ADD CONSTRAINT geoserver_pollresponsedata_deployment_id_10ade48c_uniq UNIQUE (deployment_id, poll_id, district);


--
-- Name: geoserver_pollresponsedata_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY geoserver_pollresponsedata
    ADD CONSTRAINT geoserver_pollresponsedata_pkey PRIMARY KEY (id);


--
-- Name: ibm_action_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ibm_action
    ADD CONSTRAINT ibm_action_pkey PRIMARY KEY (action_id);


--
-- Name: ibm_category_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ibm_category
    ADD CONSTRAINT ibm_category_pkey PRIMARY KEY (category_id);


--
-- Name: ibm_msg_category_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ibm_msg_category
    ADD CONSTRAINT ibm_msg_category_pkey PRIMARY KEY (msg_id);


--
-- Name: locations_location_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY locations_location
    ADD CONSTRAINT locations_location_pkey PRIMARY KEY (id);


--
-- Name: locations_locationtype_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY locations_locationtype
    ADD CONSTRAINT locations_locationtype_pkey PRIMARY KEY (slug);


--
-- Name: locations_point_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY locations_point
    ADD CONSTRAINT locations_point_pkey PRIMARY KEY (id);


--
-- Name: messagelog_message_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY messagelog_message
    ADD CONSTRAINT messagelog_message_pkey PRIMARY KEY (id);


--
-- Name: poll_category_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_category
    ADD CONSTRAINT poll_category_pkey PRIMARY KEY (id);


--
-- Name: poll_poll_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_poll_contacts
    ADD CONSTRAINT poll_poll_contacts_pkey PRIMARY KEY (id);


--
-- Name: poll_poll_contacts_poll_id_791938e7_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_poll_contacts
    ADD CONSTRAINT poll_poll_contacts_poll_id_791938e7_uniq UNIQUE (poll_id, contact_id);


--
-- Name: poll_poll_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_poll_messages
    ADD CONSTRAINT poll_poll_messages_pkey PRIMARY KEY (id);


--
-- Name: poll_poll_messages_poll_id_77ac71f9_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_poll_messages
    ADD CONSTRAINT poll_poll_messages_poll_id_77ac71f9_uniq UNIQUE (poll_id, message_id);


--
-- Name: poll_poll_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_poll
    ADD CONSTRAINT poll_poll_pkey PRIMARY KEY (id);


--
-- Name: poll_poll_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_poll_sites
    ADD CONSTRAINT poll_poll_sites_pkey PRIMARY KEY (id);


--
-- Name: poll_poll_sites_poll_id_465cf8db_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_poll_sites
    ADD CONSTRAINT poll_poll_sites_poll_id_465cf8db_uniq UNIQUE (poll_id, site_id);


--
-- Name: poll_response_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_response
    ADD CONSTRAINT poll_response_pkey PRIMARY KEY (id);


--
-- Name: poll_responsecategory_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_responsecategory
    ADD CONSTRAINT poll_responsecategory_pkey PRIMARY KEY (id);


--
-- Name: poll_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_rule
    ADD CONSTRAINT poll_rule_pkey PRIMARY KEY (id);


--
-- Name: poll_translation_field_4f9bfaa8_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_translation
    ADD CONSTRAINT poll_translation_field_4f9bfaa8_uniq UNIQUE (field, language);


--
-- Name: poll_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY poll_translation
    ADD CONSTRAINT poll_translation_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_app_module_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_app
    ADD CONSTRAINT rapidsms_app_module_key UNIQUE (module);


--
-- Name: rapidsms_app_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_app
    ADD CONSTRAINT rapidsms_app_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_backend_name_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_backend
    ADD CONSTRAINT rapidsms_backend_name_key UNIQUE (name);


--
-- Name: rapidsms_backend_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_backend
    ADD CONSTRAINT rapidsms_backend_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_connection_backend_id_identity_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_connection
    ADD CONSTRAINT rapidsms_connection_backend_id_identity_key UNIQUE (backend_id, identity);


--
-- Name: rapidsms_connection_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_connection
    ADD CONSTRAINT rapidsms_connection_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_contact_groups_contact_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_contact_groups
    ADD CONSTRAINT rapidsms_contact_groups_contact_id_group_id_key UNIQUE (contact_id, group_id);


--
-- Name: rapidsms_contact_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_contact_groups
    ADD CONSTRAINT rapidsms_contact_groups_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_contact
    ADD CONSTRAINT rapidsms_contact_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_contact_user_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_contact
    ADD CONSTRAINT rapidsms_contact_user_id_key UNIQUE (user_id);


--
-- Name: rapidsms_contact_user_permissions_contact_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_contact_user_permissions
    ADD CONSTRAINT rapidsms_contact_user_permissions_contact_id_permission_id_key UNIQUE (contact_id, permission_id);


--
-- Name: rapidsms_contact_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_contact_user_permissions
    ADD CONSTRAINT rapidsms_contact_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_httprouter_deliveryerror_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_httprouter_deliveryerror
    ADD CONSTRAINT rapidsms_httprouter_deliveryerror_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_httprouter_message_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_httprouter_message
    ADD CONSTRAINT rapidsms_httprouter_message_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_httprouter_messagebatch_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_httprouter_messagebatch
    ADD CONSTRAINT rapidsms_httprouter_messagebatch_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_xforms_binaryvalue_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_binaryvalue
    ADD CONSTRAINT rapidsms_xforms_binaryvalue_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_xforms_xform_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xform
    ADD CONSTRAINT rapidsms_xforms_xform_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_xforms_xform_restrict_to_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xform_restrict_to
    ADD CONSTRAINT rapidsms_xforms_xform_restrict_to_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_xforms_xform_restrict_to_xform_id_11741bc5_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xform_restrict_to
    ADD CONSTRAINT rapidsms_xforms_xform_restrict_to_xform_id_11741bc5_uniq UNIQUE (xform_id, group_id);


--
-- Name: rapidsms_xforms_xformfield_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xformfield
    ADD CONSTRAINT rapidsms_xforms_xformfield_pkey PRIMARY KEY (attribute_ptr_id);


--
-- Name: rapidsms_xforms_xformfieldconstraint_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xformfieldconstraint
    ADD CONSTRAINT rapidsms_xforms_xformfieldconstraint_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_xforms_xformlist_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xformlist
    ADD CONSTRAINT rapidsms_xforms_xformlist_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_xforms_xformrep_xformreportsubmission_id_140ae221_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xformreportsubmission_submissions
    ADD CONSTRAINT rapidsms_xforms_xformrep_xformreportsubmission_id_140ae221_uniq UNIQUE (xformreportsubmission_id, xformsubmission_id);


--
-- Name: rapidsms_xforms_xformreport_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xformreport
    ADD CONSTRAINT rapidsms_xforms_xformreport_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_xforms_xformreportsubmission_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xformreportsubmission
    ADD CONSTRAINT rapidsms_xforms_xformreportsubmission_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_xforms_xformreportsubmission_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xformreportsubmission_submissions
    ADD CONSTRAINT rapidsms_xforms_xformreportsubmission_submissions_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_xforms_xformsubmission_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xformsubmission
    ADD CONSTRAINT rapidsms_xforms_xformsubmission_pkey PRIMARY KEY (id);


--
-- Name: rapidsms_xforms_xformsubmissionvalue_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY rapidsms_xforms_xformsubmissionvalue
    ADD CONSTRAINT rapidsms_xforms_xformsubmissionvalue_pkey PRIMARY KEY (value_ptr_id);


--
-- Name: script_email_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY script_email
    ADD CONSTRAINT script_email_pkey PRIMARY KEY (id);


--
-- Name: script_email_recipients_email_id_4526c7c2_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY script_email_recipients
    ADD CONSTRAINT script_email_recipients_email_id_4526c7c2_uniq UNIQUE (email_id, user_id);


--
-- Name: script_email_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY script_email_recipients
    ADD CONSTRAINT script_email_recipients_pkey PRIMARY KEY (id);


--
-- Name: script_script_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY script_script
    ADD CONSTRAINT script_script_pkey PRIMARY KEY (slug);


--
-- Name: script_script_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY script_script_sites
    ADD CONSTRAINT script_script_sites_pkey PRIMARY KEY (id);


--
-- Name: script_script_sites_script_id_1faad21_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY script_script_sites
    ADD CONSTRAINT script_script_sites_script_id_1faad21_uniq UNIQUE (script_id, site_id);


--
-- Name: script_scriptprogress_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY script_scriptprogress
    ADD CONSTRAINT script_scriptprogress_pkey PRIMARY KEY (id);


--
-- Name: script_scriptresponse_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY script_scriptresponse
    ADD CONSTRAINT script_scriptresponse_pkey PRIMARY KEY (id);


--
-- Name: script_scriptsession_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY script_scriptsession
    ADD CONSTRAINT script_scriptsession_pkey PRIMARY KEY (id);


--
-- Name: script_scriptstep_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY script_scriptstep
    ADD CONSTRAINT script_scriptstep_pkey PRIMARY KEY (id);


--
-- Name: south_migrationhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY south_migrationhistory
    ADD CONSTRAINT south_migrationhistory_pkey PRIMARY KEY (id);


--
-- Name: tastypie_apiaccess_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY tastypie_apiaccess
    ADD CONSTRAINT tastypie_apiaccess_pkey PRIMARY KEY (id);


--
-- Name: tastypie_apikey_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY tastypie_apikey
    ADD CONSTRAINT tastypie_apikey_pkey PRIMARY KEY (id);


--
-- Name: tastypie_apikey_user_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY tastypie_apikey
    ADD CONSTRAINT tastypie_apikey_user_id_key UNIQUE (user_id);


--
-- Name: uganda_common_access_allowed_locations_access_id_2f595200_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY uganda_common_access_allowed_locations
    ADD CONSTRAINT uganda_common_access_allowed_locations_access_id_2f595200_uniq UNIQUE (access_id, location_id);


--
-- Name: uganda_common_access_allowed_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY uganda_common_access_allowed_locations
    ADD CONSTRAINT uganda_common_access_allowed_locations_pkey PRIMARY KEY (id);


--
-- Name: uganda_common_access_allowed_urls_access_id_27525594_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY uganda_common_access_allowed_urls
    ADD CONSTRAINT uganda_common_access_allowed_urls_access_id_27525594_uniq UNIQUE (access_id, accessurls_id);


--
-- Name: uganda_common_access_allowed_urls_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY uganda_common_access_allowed_urls
    ADD CONSTRAINT uganda_common_access_allowed_urls_pkey PRIMARY KEY (id);


--
-- Name: uganda_common_access_groups_access_id_ed231fb_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY uganda_common_access_groups
    ADD CONSTRAINT uganda_common_access_groups_access_id_ed231fb_uniq UNIQUE (access_id, group_id);


--
-- Name: uganda_common_access_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY uganda_common_access_groups
    ADD CONSTRAINT uganda_common_access_groups_pkey PRIMARY KEY (id);


--
-- Name: uganda_common_access_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY uganda_common_access
    ADD CONSTRAINT uganda_common_access_pkey PRIMARY KEY (id);


--
-- Name: uganda_common_access_user_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY uganda_common_access
    ADD CONSTRAINT uganda_common_access_user_id_key UNIQUE (user_id);


--
-- Name: uganda_common_accessurls_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY uganda_common_accessurls
    ADD CONSTRAINT uganda_common_accessurls_pkey PRIMARY KEY (id);


--
-- Name: uganda_common_accessurls_url_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY uganda_common_accessurls
    ADD CONSTRAINT uganda_common_accessurls_url_uniq UNIQUE (url);


--
-- Name: unregister_blacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY unregister_blacklist
    ADD CONSTRAINT unregister_blacklist_pkey PRIMARY KEY (id);


--
-- Name: ureport_autoreggrouprules_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_autoreggrouprules
    ADD CONSTRAINT ureport_autoreggrouprules_pkey PRIMARY KEY (id);


--
-- Name: ureport_equatellocation_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_equatellocation
    ADD CONSTRAINT ureport_equatellocation_pkey PRIMARY KEY (id);


--
-- Name: ureport_ignoredtags_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_ignoredtags
    ADD CONSTRAINT ureport_ignoredtags_pkey PRIMARY KEY (id);


--
-- Name: ureport_messageattribute_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_messageattribute
    ADD CONSTRAINT ureport_messageattribute_pkey PRIMARY KEY (id);


--
-- Name: ureport_messagedetail_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_messagedetail
    ADD CONSTRAINT ureport_messagedetail_pkey PRIMARY KEY (id);


--
-- Name: ureport_permit_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_permit
    ADD CONSTRAINT ureport_permit_pkey PRIMARY KEY (id);


--
-- Name: ureport_pollattribute_key_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_pollattribute
    ADD CONSTRAINT ureport_pollattribute_key_uniq UNIQUE (key);


--
-- Name: ureport_pollattribute_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_pollattribute
    ADD CONSTRAINT ureport_pollattribute_pkey PRIMARY KEY (id);


--
-- Name: ureport_pollattribute_values_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_pollattribute_values
    ADD CONSTRAINT ureport_pollattribute_values_pkey PRIMARY KEY (id);


--
-- Name: ureport_pollattribute_values_pollattribute_id_401bc3c_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_pollattribute_values
    ADD CONSTRAINT ureport_pollattribute_values_pollattribute_id_401bc3c_uniq UNIQUE (pollattribute_id, pollattributevalue_id);


--
-- Name: ureport_pollattributevalue_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_pollattributevalue
    ADD CONSTRAINT ureport_pollattributevalue_pkey PRIMARY KEY (id);


--
-- Name: ureport_quotebox_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_quotebox
    ADD CONSTRAINT ureport_quotebox_pkey PRIMARY KEY (id);


--
-- Name: ureport_senttomtrac_message_id_key; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_senttomtrac
    ADD CONSTRAINT ureport_senttomtrac_message_id_key UNIQUE (message_id);


--
-- Name: ureport_senttomtrac_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_senttomtrac
    ADD CONSTRAINT ureport_senttomtrac_pkey PRIMARY KEY (id);


--
-- Name: ureport_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_settings
    ADD CONSTRAINT ureport_settings_pkey PRIMARY KEY (id);


--
-- Name: ureport_topresponses_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ureport_topresponses
    ADD CONSTRAINT ureport_topresponses_pkey PRIMARY KEY (id);


--
-- Name: ussd_field_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ussd_field
    ADD CONSTRAINT ussd_field_pkey PRIMARY KEY (question_ptr_id);


--
-- Name: ussd_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ussd_menu
    ADD CONSTRAINT ussd_menu_pkey PRIMARY KEY (screen_ptr_id);


--
-- Name: ussd_navigation_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ussd_navigation
    ADD CONSTRAINT ussd_navigation_pkey PRIMARY KEY (id);


--
-- Name: ussd_question_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ussd_question
    ADD CONSTRAINT ussd_question_pkey PRIMARY KEY (screen_ptr_id);


--
-- Name: ussd_screen_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ussd_screen
    ADD CONSTRAINT ussd_screen_pkey PRIMARY KEY (slug);


--
-- Name: ussd_session_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ussd_session
    ADD CONSTRAINT ussd_session_pkey PRIMARY KEY (id);


--
-- Name: ussd_session_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ussd_session_submissions
    ADD CONSTRAINT ussd_session_submissions_pkey PRIMARY KEY (id);


--
-- Name: ussd_session_submissions_session_id_69f47b8c_uniq; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ussd_session_submissions
    ADD CONSTRAINT ussd_session_submissions_session_id_69f47b8c_uniq UNIQUE (session_id, xformsubmission_id);


--
-- Name: ussd_stubscreen_pkey; Type: CONSTRAINT; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

ALTER TABLE ONLY ussd_stubscreen
    ADD CONSTRAINT ussd_stubscreen_pkey PRIMARY KEY (screen_ptr_id);


--
-- Name: auth_group_permissions_group_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX auth_group_permissions_group_id ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX auth_group_permissions_permission_id ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX auth_permission_content_type_id ON auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX auth_user_groups_group_id ON auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX auth_user_groups_user_id ON auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_permission_id ON auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_user_id ON auth_user_user_permissions USING btree (user_id);


--
-- Name: celery_taskmeta_hidden; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX celery_taskmeta_hidden ON celery_taskmeta USING btree (hidden);


--
-- Name: celery_tasksetmeta_hidden; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX celery_tasksetmeta_hidden ON celery_tasksetmeta USING btree (hidden);


--
-- Name: contact_masstext_contacts_contact_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX contact_masstext_contacts_contact_id ON contact_masstext_contacts USING btree (contact_id);


--
-- Name: contact_masstext_contacts_masstext_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX contact_masstext_contacts_masstext_id ON contact_masstext_contacts USING btree (masstext_id);


--
-- Name: contact_masstext_sites_masstext_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX contact_masstext_sites_masstext_id ON contact_masstext_sites USING btree (masstext_id);


--
-- Name: contact_masstext_sites_site_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX contact_masstext_sites_site_id ON contact_masstext_sites USING btree (site_id);


--
-- Name: contact_masstext_user_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX contact_masstext_user_id ON contact_masstext USING btree (user_id);


--
-- Name: contact_messageflag_flag_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX contact_messageflag_flag_id ON contact_messageflag USING btree (flag_id);


--
-- Name: contact_messageflag_message_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX contact_messageflag_message_id ON contact_messageflag USING btree (message_id);


--
-- Name: django_admin_log_content_type_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX django_admin_log_content_type_id ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX django_admin_log_user_id ON django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX django_session_expire_date ON django_session USING btree (expire_date);


--
-- Name: djcelery_periodictask_crontab_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX djcelery_periodictask_crontab_id ON djcelery_periodictask USING btree (crontab_id);


--
-- Name: djcelery_periodictask_interval_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX djcelery_periodictask_interval_id ON djcelery_periodictask USING btree (interval_id);


--
-- Name: djcelery_taskstate_hidden; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX djcelery_taskstate_hidden ON djcelery_taskstate USING btree (hidden);


--
-- Name: djcelery_taskstate_name; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX djcelery_taskstate_name ON djcelery_taskstate USING btree (name);


--
-- Name: djcelery_taskstate_name_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX djcelery_taskstate_name_like ON djcelery_taskstate USING btree (name varchar_pattern_ops);


--
-- Name: djcelery_taskstate_state; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX djcelery_taskstate_state ON djcelery_taskstate USING btree (state);


--
-- Name: djcelery_taskstate_state_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX djcelery_taskstate_state_like ON djcelery_taskstate USING btree (state varchar_pattern_ops);


--
-- Name: djcelery_taskstate_tstamp; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX djcelery_taskstate_tstamp ON djcelery_taskstate USING btree (tstamp);


--
-- Name: djcelery_taskstate_worker_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX djcelery_taskstate_worker_id ON djcelery_taskstate USING btree (worker_id);


--
-- Name: djcelery_workerstate_last_heartbeat; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX djcelery_workerstate_last_heartbeat ON djcelery_workerstate USING btree (last_heartbeat);


--
-- Name: eav_attribute_enum_group_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_attribute_enum_group_id ON eav_attribute USING btree (enum_group_id);


--
-- Name: eav_attribute_site_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_attribute_site_id ON eav_attribute USING btree (site_id);


--
-- Name: eav_attribute_slug; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_attribute_slug ON eav_attribute USING btree (slug);


--
-- Name: eav_attribute_slug_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_attribute_slug_like ON eav_attribute USING btree (slug varchar_pattern_ops);


--
-- Name: eav_encounter_patient_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_encounter_patient_id ON eav_encounter USING btree (patient_id);


--
-- Name: eav_enumgroup_enums_enumgroup_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_enumgroup_enums_enumgroup_id ON eav_enumgroup_enums USING btree (enumgroup_id);


--
-- Name: eav_enumgroup_enums_enumvalue_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_enumgroup_enums_enumvalue_id ON eav_enumgroup_enums USING btree (enumvalue_id);


--
-- Name: eav_value_attribute_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_value_attribute_id ON eav_value USING btree (attribute_id);


--
-- Name: eav_value_entity_ct_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_value_entity_ct_id ON eav_value USING btree (entity_ct_id);


--
-- Name: eav_value_generic_value_ct_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_value_generic_value_ct_id ON eav_value USING btree (generic_value_ct_id);


--
-- Name: eav_value_value_enum_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX eav_value_value_enum_id ON eav_value USING btree (value_enum_id);


--
-- Name: generic_dashboard_user_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX generic_dashboard_user_id ON generic_dashboard USING btree (user_id);


--
-- Name: generic_module_dashboard_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX generic_module_dashboard_id ON generic_module USING btree (dashboard_id);


--
-- Name: generic_moduleparams_module_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX generic_moduleparams_module_id ON generic_moduleparams USING btree (module_id);


--
-- Name: ibm_msg_category_action_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ibm_msg_category_action_id ON ibm_msg_category USING btree (action_id);


--
-- Name: ibm_msg_category_category_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ibm_msg_category_category_id ON ibm_msg_category USING btree (category_id);


--
-- Name: locations_location_level; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX locations_location_level ON locations_location USING btree (level);


--
-- Name: locations_location_lft; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX locations_location_lft ON locations_location USING btree (lft);


--
-- Name: locations_location_parent_type_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX locations_location_parent_type_id ON locations_location USING btree (parent_type_id);


--
-- Name: locations_location_point_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX locations_location_point_id ON locations_location USING btree (point_id);


--
-- Name: locations_location_rght; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX locations_location_rght ON locations_location USING btree (rght);


--
-- Name: locations_location_tree_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX locations_location_tree_id ON locations_location USING btree (tree_id);


--
-- Name: locations_location_tree_parent_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX locations_location_tree_parent_id ON locations_location USING btree (tree_parent_id);


--
-- Name: locations_location_type_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX locations_location_type_id ON locations_location USING btree (type_id);


--
-- Name: locations_location_type_id_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX locations_location_type_id_like ON locations_location USING btree (type_id varchar_pattern_ops);


--
-- Name: messagelog_message_connection_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX messagelog_message_connection_id ON messagelog_message USING btree (connection_id);


--
-- Name: messagelog_message_contact_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX messagelog_message_contact_id ON messagelog_message USING btree (contact_id);


--
-- Name: poll_category_poll_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_category_poll_id ON poll_category USING btree (poll_id);


--
-- Name: poll_poll_contacts_contact_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_poll_contacts_contact_id ON poll_poll_contacts USING btree (contact_id);


--
-- Name: poll_poll_contacts_poll_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_poll_contacts_poll_id ON poll_poll_contacts USING btree (poll_id);


--
-- Name: poll_poll_messages_message_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_poll_messages_message_id ON poll_poll_messages USING btree (message_id);


--
-- Name: poll_poll_messages_poll_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_poll_messages_poll_id ON poll_poll_messages USING btree (poll_id);


--
-- Name: poll_poll_sites_poll_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_poll_sites_poll_id ON poll_poll_sites USING btree (poll_id);


--
-- Name: poll_poll_sites_site_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_poll_sites_site_id ON poll_poll_sites USING btree (site_id);


--
-- Name: poll_poll_type; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_poll_type ON poll_poll USING btree (type);


--
-- Name: poll_poll_type_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_poll_type_like ON poll_poll USING btree (type varchar_pattern_ops);


--
-- Name: poll_poll_user_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_poll_user_id ON poll_poll USING btree (user_id);


--
-- Name: poll_response_contact_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_response_contact_id ON poll_response USING btree (contact_id);


--
-- Name: poll_response_message_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_response_message_id ON poll_response USING btree (message_id);


--
-- Name: poll_response_poll_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_response_poll_id ON poll_response USING btree (poll_id);


--
-- Name: poll_responsecategory_category_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_responsecategory_category_id ON poll_responsecategory USING btree (category_id);


--
-- Name: poll_responsecategory_response_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_responsecategory_response_id ON poll_responsecategory USING btree (response_id);


--
-- Name: poll_responsecategory_user_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_responsecategory_user_id ON poll_responsecategory USING btree (user_id);


--
-- Name: poll_rule_category_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_rule_category_id ON poll_rule USING btree (category_id);


--
-- Name: poll_translation_field; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_translation_field ON poll_translation USING btree (field);


--
-- Name: poll_translation_field_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_translation_field_like ON poll_translation USING btree (field text_pattern_ops);


--
-- Name: poll_translation_language; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_translation_language ON poll_translation USING btree (language);


--
-- Name: poll_translation_language_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX poll_translation_language_like ON poll_translation USING btree (language varchar_pattern_ops);


--
-- Name: rapidsms_connection_backend_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_connection_backend_id ON rapidsms_connection USING btree (backend_id);


--
-- Name: rapidsms_connection_contact_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_connection_contact_id ON rapidsms_connection USING btree (contact_id);


--
-- Name: rapidsms_contact_colline_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_contact_colline_id ON rapidsms_contact USING btree (colline_id);


--
-- Name: rapidsms_contact_commune_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_contact_commune_id ON rapidsms_contact USING btree (commune_id);


--
-- Name: rapidsms_contact_groups_contact_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_contact_groups_contact_id ON rapidsms_contact_groups USING btree (contact_id);


--
-- Name: rapidsms_contact_groups_group_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_contact_groups_group_id ON rapidsms_contact_groups USING btree (group_id);


--
-- Name: rapidsms_contact_reporting_location_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_contact_reporting_location_id ON rapidsms_contact USING btree (reporting_location_id);


--
-- Name: rapidsms_contact_user_permissions_contact_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_contact_user_permissions_contact_id ON rapidsms_contact_user_permissions USING btree (contact_id);


--
-- Name: rapidsms_contact_user_permissions_permission_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_contact_user_permissions_permission_id ON rapidsms_contact_user_permissions USING btree (permission_id);


--
-- Name: rapidsms_httprouter_deliveryerror_message_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_httprouter_deliveryerror_message_id ON rapidsms_httprouter_deliveryerror USING btree (message_id);


--
-- Name: rapidsms_httprouter_message_batch_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_httprouter_message_batch_id ON rapidsms_httprouter_message USING btree (batch_id);


--
-- Name: rapidsms_httprouter_message_connection_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_httprouter_message_connection_id ON rapidsms_httprouter_message USING btree (connection_id);


--
-- Name: rapidsms_httprouter_message_in_response_to_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_httprouter_message_in_response_to_id ON rapidsms_httprouter_message USING btree (in_response_to_id);


--
-- Name: rapidsms_httprouter_message_priority; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_httprouter_message_priority ON rapidsms_httprouter_message USING btree (priority);


--
-- Name: rapidsms_xforms_xform_keyword; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xform_keyword ON rapidsms_xforms_xform USING btree (keyword);


--
-- Name: rapidsms_xforms_xform_keyword_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xform_keyword_like ON rapidsms_xforms_xform USING btree (keyword varchar_pattern_ops);


--
-- Name: rapidsms_xforms_xform_owner_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xform_owner_id ON rapidsms_xforms_xform USING btree (owner_id);


--
-- Name: rapidsms_xforms_xform_restrict_to_group_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xform_restrict_to_group_id ON rapidsms_xforms_xform_restrict_to USING btree (group_id);


--
-- Name: rapidsms_xforms_xform_restrict_to_xform_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xform_restrict_to_xform_id ON rapidsms_xforms_xform_restrict_to USING btree (xform_id);


--
-- Name: rapidsms_xforms_xform_site_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xform_site_id ON rapidsms_xforms_xform USING btree (site_id);


--
-- Name: rapidsms_xforms_xformfield_command; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformfield_command ON rapidsms_xforms_xformfield USING btree (command);


--
-- Name: rapidsms_xforms_xformfield_command_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformfield_command_like ON rapidsms_xforms_xformfield USING btree (command varchar_pattern_ops);


--
-- Name: rapidsms_xforms_xformfield_field_type; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformfield_field_type ON rapidsms_xforms_xformfield USING btree (field_type);


--
-- Name: rapidsms_xforms_xformfield_field_type_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformfield_field_type_like ON rapidsms_xforms_xformfield USING btree (field_type varchar_pattern_ops);


--
-- Name: rapidsms_xforms_xformfield_xform_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformfield_xform_id ON rapidsms_xforms_xformfield USING btree (xform_id);


--
-- Name: rapidsms_xforms_xformfieldconstraint_field_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformfieldconstraint_field_id ON rapidsms_xforms_xformfieldconstraint USING btree (field_id);


--
-- Name: rapidsms_xforms_xformlist_report_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformlist_report_id ON rapidsms_xforms_xformlist USING btree (report_id);


--
-- Name: rapidsms_xforms_xformlist_xform_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformlist_xform_id ON rapidsms_xforms_xformlist USING btree (xform_id);


--
-- Name: rapidsms_xforms_xformreportsubmission_report_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformreportsubmission_report_id ON rapidsms_xforms_xformreportsubmission USING btree (report_id);


--
-- Name: rapidsms_xforms_xformreportsubmission_submissions_xformrepof94f; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformreportsubmission_submissions_xformrepof94f ON rapidsms_xforms_xformreportsubmission_submissions USING btree (xformreportsubmission_id);


--
-- Name: rapidsms_xforms_xformreportsubmission_submissions_xformsubm7a61; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformreportsubmission_submissions_xformsubm7a61 ON rapidsms_xforms_xformreportsubmission_submissions USING btree (xformsubmission_id);


--
-- Name: rapidsms_xforms_xformsubmission_connection_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformsubmission_connection_id ON rapidsms_xforms_xformsubmission USING btree (connection_id);


--
-- Name: rapidsms_xforms_xformsubmission_message_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformsubmission_message_id ON rapidsms_xforms_xformsubmission USING btree (message_id);


--
-- Name: rapidsms_xforms_xformsubmission_xform_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformsubmission_xform_id ON rapidsms_xforms_xformsubmission USING btree (xform_id);


--
-- Name: rapidsms_xforms_xformsubmissionvalue_submission_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX rapidsms_xforms_xformsubmissionvalue_submission_id ON rapidsms_xforms_xformsubmissionvalue USING btree (submission_id);


--
-- Name: script_email_recipients_email_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_email_recipients_email_id ON script_email_recipients USING btree (email_id);


--
-- Name: script_email_recipients_user_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_email_recipients_user_id ON script_email_recipients USING btree (user_id);


--
-- Name: script_script_sites_script_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_script_sites_script_id ON script_script_sites USING btree (script_id);


--
-- Name: script_script_sites_script_id_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_script_sites_script_id_like ON script_script_sites USING btree (script_id varchar_pattern_ops);


--
-- Name: script_script_sites_site_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_script_sites_site_id ON script_script_sites USING btree (site_id);


--
-- Name: script_scriptprogress_connection_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptprogress_connection_id ON script_scriptprogress USING btree (connection_id);


--
-- Name: script_scriptprogress_script_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptprogress_script_id ON script_scriptprogress USING btree (script_id);


--
-- Name: script_scriptprogress_script_id_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptprogress_script_id_like ON script_scriptprogress USING btree (script_id varchar_pattern_ops);


--
-- Name: script_scriptprogress_step_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptprogress_step_id ON script_scriptprogress USING btree (step_id);


--
-- Name: script_scriptresponse_response_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptresponse_response_id ON script_scriptresponse USING btree (response_id);


--
-- Name: script_scriptresponse_session_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptresponse_session_id ON script_scriptresponse USING btree (session_id);


--
-- Name: script_scriptsession_connection_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptsession_connection_id ON script_scriptsession USING btree (connection_id);


--
-- Name: script_scriptsession_script_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptsession_script_id ON script_scriptsession USING btree (script_id);


--
-- Name: script_scriptsession_script_id_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptsession_script_id_like ON script_scriptsession USING btree (script_id varchar_pattern_ops);


--
-- Name: script_scriptstep_email_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptstep_email_id ON script_scriptstep USING btree (email_id);


--
-- Name: script_scriptstep_poll_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptstep_poll_id ON script_scriptstep USING btree (poll_id);


--
-- Name: script_scriptstep_script_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptstep_script_id ON script_scriptstep USING btree (script_id);


--
-- Name: script_scriptstep_script_id_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX script_scriptstep_script_id_like ON script_scriptstep USING btree (script_id varchar_pattern_ops);


--
-- Name: tastypie_apikey_key; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX tastypie_apikey_key ON tastypie_apikey USING btree (key);


--
-- Name: uganda_common_access_allowed_locations_access_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX uganda_common_access_allowed_locations_access_id ON uganda_common_access_allowed_locations USING btree (access_id);


--
-- Name: uganda_common_access_allowed_locations_location_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX uganda_common_access_allowed_locations_location_id ON uganda_common_access_allowed_locations USING btree (location_id);


--
-- Name: uganda_common_access_allowed_urls_access_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX uganda_common_access_allowed_urls_access_id ON uganda_common_access_allowed_urls USING btree (access_id);


--
-- Name: uganda_common_access_allowed_urls_accessurls_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX uganda_common_access_allowed_urls_accessurls_id ON uganda_common_access_allowed_urls USING btree (accessurls_id);


--
-- Name: uganda_common_access_groups_access_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX uganda_common_access_groups_access_id ON uganda_common_access_groups USING btree (access_id);


--
-- Name: uganda_common_access_groups_group_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX uganda_common_access_groups_group_id ON uganda_common_access_groups USING btree (group_id);


--
-- Name: unregister_blacklist_connection_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX unregister_blacklist_connection_id ON unregister_blacklist USING btree (connection_id);


--
-- Name: ureport_autoreggrouprules_group_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_autoreggrouprules_group_id ON ureport_autoreggrouprules USING btree (group_id);


--
-- Name: ureport_equatellocation_location_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_equatellocation_location_id ON ureport_equatellocation USING btree (location_id);


--
-- Name: ureport_ignoredtags_poll_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_ignoredtags_poll_id ON ureport_ignoredtags USING btree (poll_id);


--
-- Name: ureport_messageattribute_name; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_messageattribute_name ON ureport_messageattribute USING btree (name);


--
-- Name: ureport_messageattribute_name_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_messageattribute_name_like ON ureport_messageattribute USING btree (name varchar_pattern_ops);


--
-- Name: ureport_messagedetail_attribute_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_messagedetail_attribute_id ON ureport_messagedetail USING btree (attribute_id);


--
-- Name: ureport_messagedetail_message_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_messagedetail_message_id ON ureport_messagedetail USING btree (message_id);


--
-- Name: ureport_permit_user_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_permit_user_id ON ureport_permit USING btree (user_id);


--
-- Name: ureport_pollattribute_values_pollattribute_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_pollattribute_values_pollattribute_id ON ureport_pollattribute_values USING btree (pollattribute_id);


--
-- Name: ureport_pollattribute_values_pollattributevalue_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_pollattribute_values_pollattributevalue_id ON ureport_pollattribute_values USING btree (pollattributevalue_id);


--
-- Name: ureport_pollattributevalue_poll_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_pollattributevalue_poll_id ON ureport_pollattributevalue USING btree (poll_id);


--
-- Name: ureport_settings_user_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_settings_user_id ON ureport_settings USING btree (user_id);


--
-- Name: ureport_topresponses_poll_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ureport_topresponses_poll_id ON ureport_topresponses USING btree (poll_id);


--
-- Name: ussd_field_field_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_field_field_id ON ussd_field USING btree (field_id);


--
-- Name: ussd_navigation_screen_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_navigation_screen_id ON ussd_navigation USING btree (screen_id);


--
-- Name: ussd_navigation_screen_id_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_navigation_screen_id_like ON ussd_navigation USING btree (screen_id varchar_pattern_ops);


--
-- Name: ussd_navigation_session_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_navigation_session_id ON ussd_navigation USING btree (session_id);


--
-- Name: ussd_question_next_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_question_next_id ON ussd_question USING btree (next_id);


--
-- Name: ussd_question_next_id_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_question_next_id_like ON ussd_question USING btree (next_id varchar_pattern_ops);


--
-- Name: ussd_screen_level; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_screen_level ON ussd_screen USING btree (level);


--
-- Name: ussd_screen_lft; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_screen_lft ON ussd_screen USING btree (lft);


--
-- Name: ussd_screen_parent_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_screen_parent_id ON ussd_screen USING btree (parent_id);


--
-- Name: ussd_screen_parent_id_like; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_screen_parent_id_like ON ussd_screen USING btree (parent_id varchar_pattern_ops);


--
-- Name: ussd_screen_rght; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_screen_rght ON ussd_screen USING btree (rght);


--
-- Name: ussd_screen_tree_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_screen_tree_id ON ussd_screen USING btree (tree_id);


--
-- Name: ussd_session_connection_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_session_connection_id ON ussd_session USING btree (connection_id);


--
-- Name: ussd_session_submissions_session_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_session_submissions_session_id ON ussd_session_submissions USING btree (session_id);


--
-- Name: ussd_session_submissions_xformsubmission_id; Type: INDEX; Schema: public; Owner: helpdeskadmin; Tablespace: 
--

CREATE INDEX ussd_session_submissions_xformsubmission_id ON ussd_session_submissions USING btree (xformsubmission_id);


--
-- Name: update_contact; Type: TRIGGER; Schema: public; Owner: helpdeskadmin
--

CREATE TRIGGER update_contact AFTER INSERT ON rapidsms_contact FOR EACH ROW EXECUTE PROCEDURE contact_update();


--
-- Name: update_contact_message; Type: TRIGGER; Schema: public; Owner: helpdeskadmin
--

CREATE TRIGGER update_contact_message AFTER INSERT ON rapidsms_httprouter_message FOR EACH ROW EXECUTE PROCEDURE contact_update_message();


--
-- Name: update_contact_update; Type: TRIGGER; Schema: public; Owner: helpdeskadmin
--

CREATE TRIGGER update_contact_update AFTER UPDATE ON rapidsms_contact FOR EACH ROW EXECUTE PROCEDURE contact_update();


--
-- Name: access_id_refs_id_51a41a8d; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access_allowed_locations
    ADD CONSTRAINT access_id_refs_id_51a41a8d FOREIGN KEY (access_id) REFERENCES uganda_common_access(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: access_id_refs_id_520a7423; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access_groups
    ADD CONSTRAINT access_id_refs_id_520a7423 FOREIGN KEY (access_id) REFERENCES uganda_common_access(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: access_id_refs_id_5240361c; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access_allowed_urls
    ADD CONSTRAINT access_id_refs_id_5240361c FOREIGN KEY (access_id) REFERENCES uganda_common_access(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accessurls_id_refs_id_51b6bcc6; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access_allowed_urls
    ADD CONSTRAINT accessurls_id_refs_id_51b6bcc6 FOREIGN KEY (accessurls_id) REFERENCES uganda_common_accessurls(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: action_id_refs_action_id_7c92cc21; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ibm_msg_category
    ADD CONSTRAINT action_id_refs_action_id_7c92cc21 FOREIGN KEY (action_id) REFERENCES ibm_action(action_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: attribute_id_refs_id_14dfc799; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_messagedetail
    ADD CONSTRAINT attribute_id_refs_id_14dfc799 FOREIGN KEY (attribute_id) REFERENCES ureport_messageattribute(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: attribute_ptr_id_refs_id_68819227; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformfield
    ADD CONSTRAINT attribute_ptr_id_refs_id_68819227 FOREIGN KEY (attribute_ptr_id) REFERENCES eav_attribute(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: batch_id_refs_id_59cd8fc4; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_httprouter_message
    ADD CONSTRAINT batch_id_refs_id_59cd8fc4 FOREIGN KEY (batch_id) REFERENCES rapidsms_httprouter_messagebatch(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: category_id_refs_category_id_cef1f91; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ibm_msg_category
    ADD CONSTRAINT category_id_refs_category_id_cef1f91 FOREIGN KEY (category_id) REFERENCES ibm_category(category_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: category_id_refs_id_11729e5f; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_rule
    ADD CONSTRAINT category_id_refs_id_11729e5f FOREIGN KEY (category_id) REFERENCES poll_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: category_id_refs_id_f89b740; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_responsecategory
    ADD CONSTRAINT category_id_refs_id_f89b740 FOREIGN KEY (category_id) REFERENCES poll_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: connection_id_refs_id_421f5b43; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformsubmission
    ADD CONSTRAINT connection_id_refs_id_421f5b43 FOREIGN KEY (connection_id) REFERENCES rapidsms_connection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: connection_id_refs_id_481046fb; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptprogress
    ADD CONSTRAINT connection_id_refs_id_481046fb FOREIGN KEY (connection_id) REFERENCES rapidsms_connection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: connection_id_refs_id_5ae2582a; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_session
    ADD CONSTRAINT connection_id_refs_id_5ae2582a FOREIGN KEY (connection_id) REFERENCES rapidsms_connection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: connection_id_refs_id_681c7d3; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptsession
    ADD CONSTRAINT connection_id_refs_id_681c7d3 FOREIGN KEY (connection_id) REFERENCES rapidsms_connection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: connection_id_refs_id_7b54c98a; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_httprouter_message
    ADD CONSTRAINT connection_id_refs_id_7b54c98a FOREIGN KEY (connection_id) REFERENCES rapidsms_connection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contact_id_refs_id_41a8133c; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_masstext_contacts
    ADD CONSTRAINT contact_id_refs_id_41a8133c FOREIGN KEY (contact_id) REFERENCES rapidsms_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contact_id_refs_id_43d2c0c3; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact_groups
    ADD CONSTRAINT contact_id_refs_id_43d2c0c3 FOREIGN KEY (contact_id) REFERENCES rapidsms_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contact_id_refs_id_543b81b; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_response
    ADD CONSTRAINT contact_id_refs_id_543b81b FOREIGN KEY (contact_id) REFERENCES rapidsms_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contact_id_refs_id_65f02e9f; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact_user_permissions
    ADD CONSTRAINT contact_id_refs_id_65f02e9f FOREIGN KEY (contact_id) REFERENCES rapidsms_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contact_id_refs_id_7c4a8d16; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll_contacts
    ADD CONSTRAINT contact_id_refs_id_7c4a8d16 FOREIGN KEY (contact_id) REFERENCES rapidsms_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: content_type_id_refs_id_728de91f; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT content_type_id_refs_id_728de91f FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: crontab_id_refs_id_1400a18c; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT crontab_id_refs_id_1400a18c FOREIGN KEY (crontab_id) REFERENCES djcelery_crontabschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dashboard_id_refs_id_290fa892; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY generic_module
    ADD CONSTRAINT dashboard_id_refs_id_290fa892 FOREIGN KEY (dashboard_id) REFERENCES generic_dashboard(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_content_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_fkey FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: eav_attribute_enum_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_attribute
    ADD CONSTRAINT eav_attribute_enum_group_id_fkey FOREIGN KEY (enum_group_id) REFERENCES eav_enumgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: eav_attribute_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_attribute
    ADD CONSTRAINT eav_attribute_site_id_fkey FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: eav_encounter_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_encounter
    ADD CONSTRAINT eav_encounter_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES eav_patient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: eav_enumgroup_enums_enumvalue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_enumgroup_enums
    ADD CONSTRAINT eav_enumgroup_enums_enumvalue_id_fkey FOREIGN KEY (enumvalue_id) REFERENCES eav_enumvalue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: eav_value_attribute_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_value
    ADD CONSTRAINT eav_value_attribute_id_fkey FOREIGN KEY (attribute_id) REFERENCES eav_attribute(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: eav_value_entity_ct_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_value
    ADD CONSTRAINT eav_value_entity_ct_id_fkey FOREIGN KEY (entity_ct_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: eav_value_generic_value_ct_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_value
    ADD CONSTRAINT eav_value_generic_value_ct_id_fkey FOREIGN KEY (generic_value_ct_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: eav_value_value_enum_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_value
    ADD CONSTRAINT eav_value_value_enum_id_fkey FOREIGN KEY (value_enum_id) REFERENCES eav_enumvalue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: email_id_refs_id_1c3a7a6b; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_email_recipients
    ADD CONSTRAINT email_id_refs_id_1c3a7a6b FOREIGN KEY (email_id) REFERENCES script_email(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: email_id_refs_id_6dd34d23; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptstep
    ADD CONSTRAINT email_id_refs_id_6dd34d23 FOREIGN KEY (email_id) REFERENCES script_email(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: enumgroup_id_refs_id_4af518a6; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY eav_enumgroup_enums
    ADD CONSTRAINT enumgroup_id_refs_id_4af518a6 FOREIGN KEY (enumgroup_id) REFERENCES eav_enumgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: field_id_refs_attribute_ptr_id_49371d78; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformfieldconstraint
    ADD CONSTRAINT field_id_refs_attribute_ptr_id_49371d78 FOREIGN KEY (field_id) REFERENCES rapidsms_xforms_xformfield(attribute_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: field_id_refs_attribute_ptr_id_966b8d1; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_field
    ADD CONSTRAINT field_id_refs_attribute_ptr_id_966b8d1 FOREIGN KEY (field_id) REFERENCES rapidsms_xforms_xformfield(attribute_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: flag_id_refs_id_5e20cc9d; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_messageflag
    ADD CONSTRAINT flag_id_refs_id_5e20cc9d FOREIGN KEY (flag_id) REFERENCES contact_flag(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_398eff5; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xform_restrict_to
    ADD CONSTRAINT group_id_refs_id_398eff5 FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_3cea63fe; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT group_id_refs_id_3cea63fe FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_66a2eeec; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access_groups
    ADD CONSTRAINT group_id_refs_id_66a2eeec FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_9e30301; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_autoreggrouprules
    ADD CONSTRAINT group_id_refs_id_9e30301 FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: in_response_to_id_refs_id_414fa173; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_httprouter_message
    ADD CONSTRAINT in_response_to_id_refs_id_414fa173 FOREIGN KEY (in_response_to_id) REFERENCES rapidsms_httprouter_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: interval_id_refs_id_dfabcb7; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT interval_id_refs_id_dfabcb7 FOREIGN KEY (interval_id) REFERENCES djcelery_intervalschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: location_id_refs_id_28a0e554; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access_allowed_locations
    ADD CONSTRAINT location_id_refs_id_28a0e554 FOREIGN KEY (location_id) REFERENCES locations_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: location_id_refs_id_66c12668; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_equatellocation
    ADD CONSTRAINT location_id_refs_id_66c12668 FOREIGN KEY (location_id) REFERENCES locations_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: locations_location_parent_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY locations_location
    ADD CONSTRAINT locations_location_parent_type_id_fkey FOREIGN KEY (parent_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: locations_location_point_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY locations_location
    ADD CONSTRAINT locations_location_point_id_fkey FOREIGN KEY (point_id) REFERENCES locations_point(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: locations_location_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY locations_location
    ADD CONSTRAINT locations_location_type_id_fkey FOREIGN KEY (type_id) REFERENCES locations_locationtype(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: masstext_id_refs_id_2d066a7e; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_masstext_contacts
    ADD CONSTRAINT masstext_id_refs_id_2d066a7e FOREIGN KEY (masstext_id) REFERENCES contact_masstext(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: masstext_id_refs_id_6b388374; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_masstext_sites
    ADD CONSTRAINT masstext_id_refs_id_6b388374 FOREIGN KEY (masstext_id) REFERENCES contact_masstext(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: message_id_refs_id_29df6fde; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_messagedetail
    ADD CONSTRAINT message_id_refs_id_29df6fde FOREIGN KEY (message_id) REFERENCES rapidsms_httprouter_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: message_id_refs_id_2da916fa; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformsubmission
    ADD CONSTRAINT message_id_refs_id_2da916fa FOREIGN KEY (message_id) REFERENCES rapidsms_httprouter_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: message_id_refs_id_35eb5982; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_httprouter_deliveryerror
    ADD CONSTRAINT message_id_refs_id_35eb5982 FOREIGN KEY (message_id) REFERENCES rapidsms_httprouter_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: message_id_refs_id_62c9e2de; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_senttomtrac
    ADD CONSTRAINT message_id_refs_id_62c9e2de FOREIGN KEY (message_id) REFERENCES rapidsms_httprouter_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: message_id_refs_id_67087f0e; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_messageflag
    ADD CONSTRAINT message_id_refs_id_67087f0e FOREIGN KEY (message_id) REFERENCES rapidsms_httprouter_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: message_id_refs_id_710d909d; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_response
    ADD CONSTRAINT message_id_refs_id_710d909d FOREIGN KEY (message_id) REFERENCES rapidsms_httprouter_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: message_id_refs_id_75ab6d53; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll_messages
    ADD CONSTRAINT message_id_refs_id_75ab6d53 FOREIGN KEY (message_id) REFERENCES rapidsms_httprouter_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: messagelog_message_connection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY messagelog_message
    ADD CONSTRAINT messagelog_message_connection_id_fkey FOREIGN KEY (connection_id) REFERENCES rapidsms_connection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: messagelog_message_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY messagelog_message
    ADD CONSTRAINT messagelog_message_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES rapidsms_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: module_id_refs_id_787e4a29; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY generic_moduleparams
    ADD CONSTRAINT module_id_refs_id_787e4a29 FOREIGN KEY (module_id) REFERENCES generic_module(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: msg_id_refs_id_72cbdd80; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ibm_msg_category
    ADD CONSTRAINT msg_id_refs_id_72cbdd80 FOREIGN KEY (msg_id) REFERENCES rapidsms_httprouter_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: next_id_refs_slug_6d7de2e7; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_question
    ADD CONSTRAINT next_id_refs_slug_6d7de2e7 FOREIGN KEY (next_id) REFERENCES ussd_screen(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: owner_id_refs_id_537a002b; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xform
    ADD CONSTRAINT owner_id_refs_id_537a002b FOREIGN KEY (owner_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: parent_id_refs_slug_39aabefb; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_screen
    ADD CONSTRAINT parent_id_refs_slug_39aabefb FOREIGN KEY (parent_id) REFERENCES ussd_screen(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poll_id_refs_id_11b37981; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_pollattributevalue
    ADD CONSTRAINT poll_id_refs_id_11b37981 FOREIGN KEY (poll_id) REFERENCES poll_poll(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poll_id_refs_id_39d49647; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll_messages
    ADD CONSTRAINT poll_id_refs_id_39d49647 FOREIGN KEY (poll_id) REFERENCES poll_poll(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poll_id_refs_id_3b1b8f82; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_topresponses
    ADD CONSTRAINT poll_id_refs_id_3b1b8f82 FOREIGN KEY (poll_id) REFERENCES poll_poll(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poll_id_refs_id_4607f64e; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll_contacts
    ADD CONSTRAINT poll_id_refs_id_4607f64e FOREIGN KEY (poll_id) REFERENCES poll_poll(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poll_id_refs_id_4e8e81b7; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptstep
    ADD CONSTRAINT poll_id_refs_id_4e8e81b7 FOREIGN KEY (poll_id) REFERENCES poll_poll(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poll_id_refs_id_57423c98; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll_sites
    ADD CONSTRAINT poll_id_refs_id_57423c98 FOREIGN KEY (poll_id) REFERENCES poll_poll(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poll_id_refs_id_6caee570; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_category
    ADD CONSTRAINT poll_id_refs_id_6caee570 FOREIGN KEY (poll_id) REFERENCES poll_poll(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poll_id_refs_id_732ac857; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_response
    ADD CONSTRAINT poll_id_refs_id_732ac857 FOREIGN KEY (poll_id) REFERENCES poll_poll(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poll_id_refs_id_7bd5268f; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_ignoredtags
    ADD CONSTRAINT poll_id_refs_id_7bd5268f FOREIGN KEY (poll_id) REFERENCES poll_poll(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pollattribute_id_refs_id_1dd0eb65; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_pollattribute_values
    ADD CONSTRAINT pollattribute_id_refs_id_1dd0eb65 FOREIGN KEY (pollattribute_id) REFERENCES ureport_pollattribute(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pollattributevalue_id_refs_id_47481957; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_pollattribute_values
    ADD CONSTRAINT pollattributevalue_id_refs_id_47481957 FOREIGN KEY (pollattributevalue_id) REFERENCES ureport_pollattributevalue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: question_ptr_id_refs_screen_ptr_id_68cdab06; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_field
    ADD CONSTRAINT question_ptr_id_refs_screen_ptr_id_68cdab06 FOREIGN KEY (question_ptr_id) REFERENCES ussd_question(screen_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rapidsms_connection_backend_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_connection
    ADD CONSTRAINT rapidsms_connection_backend_id_fkey FOREIGN KEY (backend_id) REFERENCES rapidsms_backend(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rapidsms_connection_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_connection
    ADD CONSTRAINT rapidsms_connection_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES rapidsms_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rapidsms_contact_colline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact
    ADD CONSTRAINT rapidsms_contact_colline_id_fkey FOREIGN KEY (colline_id) REFERENCES locations_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rapidsms_contact_commune_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact
    ADD CONSTRAINT rapidsms_contact_commune_id_fkey FOREIGN KEY (commune_id) REFERENCES locations_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rapidsms_contact_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact_groups
    ADD CONSTRAINT rapidsms_contact_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rapidsms_contact_reporting_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact
    ADD CONSTRAINT rapidsms_contact_reporting_location_id_fkey FOREIGN KEY (reporting_location_id) REFERENCES locations_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rapidsms_contact_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact
    ADD CONSTRAINT rapidsms_contact_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rapidsms_contact_user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_contact_user_permissions
    ADD CONSTRAINT rapidsms_contact_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: report_id_refs_id_2dfe35bd; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformreportsubmission
    ADD CONSTRAINT report_id_refs_id_2dfe35bd FOREIGN KEY (report_id) REFERENCES rapidsms_xforms_xformreport(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: report_id_refs_id_407c9685; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformlist
    ADD CONSTRAINT report_id_refs_id_407c9685 FOREIGN KEY (report_id) REFERENCES rapidsms_xforms_xformreport(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: response_id_refs_id_49107774; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptresponse
    ADD CONSTRAINT response_id_refs_id_49107774 FOREIGN KEY (response_id) REFERENCES poll_response(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: response_id_refs_id_5854f425; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_responsecategory
    ADD CONSTRAINT response_id_refs_id_5854f425 FOREIGN KEY (response_id) REFERENCES poll_response(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: screen_id_refs_slug_d7bb27f; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_navigation
    ADD CONSTRAINT screen_id_refs_slug_d7bb27f FOREIGN KEY (screen_id) REFERENCES ussd_screen(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: screen_ptr_id_refs_slug_13a3dca2; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_menu
    ADD CONSTRAINT screen_ptr_id_refs_slug_13a3dca2 FOREIGN KEY (screen_ptr_id) REFERENCES ussd_screen(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: screen_ptr_id_refs_slug_6d7de2e7; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_question
    ADD CONSTRAINT screen_ptr_id_refs_slug_6d7de2e7 FOREIGN KEY (screen_ptr_id) REFERENCES ussd_screen(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: screen_ptr_id_refs_slug_7c2aecf3; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_stubscreen
    ADD CONSTRAINT screen_ptr_id_refs_slug_7c2aecf3 FOREIGN KEY (screen_ptr_id) REFERENCES ussd_screen(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: script_id_refs_slug_23e761c8; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_script_sites
    ADD CONSTRAINT script_id_refs_slug_23e761c8 FOREIGN KEY (script_id) REFERENCES script_script(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: script_id_refs_slug_3e150232; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptprogress
    ADD CONSTRAINT script_id_refs_slug_3e150232 FOREIGN KEY (script_id) REFERENCES script_script(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: script_id_refs_slug_73a4d6bc; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptsession
    ADD CONSTRAINT script_id_refs_slug_73a4d6bc FOREIGN KEY (script_id) REFERENCES script_script(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: script_id_refs_slug_7684eb3d; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptstep
    ADD CONSTRAINT script_id_refs_slug_7684eb3d FOREIGN KEY (script_id) REFERENCES script_script(slug) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: session_id_refs_id_17def1d; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_session_submissions
    ADD CONSTRAINT session_id_refs_id_17def1d FOREIGN KEY (session_id) REFERENCES ussd_session(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: session_id_refs_id_1f1d75e; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_navigation
    ADD CONSTRAINT session_id_refs_id_1f1d75e FOREIGN KEY (session_id) REFERENCES ussd_session(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: session_id_refs_id_62c60d49; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptresponse
    ADD CONSTRAINT session_id_refs_id_62c60d49 FOREIGN KEY (session_id) REFERENCES script_scriptsession(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_id_refs_id_18bcfe38; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_masstext_sites
    ADD CONSTRAINT site_id_refs_id_18bcfe38 FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_id_refs_id_257e7be2; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll_sites
    ADD CONSTRAINT site_id_refs_id_257e7be2 FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_id_refs_id_778f0832; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_script_sites
    ADD CONSTRAINT site_id_refs_id_778f0832 FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_id_refs_id_ccd0c7e; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xform
    ADD CONSTRAINT site_id_refs_id_ccd0c7e FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: step_id_refs_id_6e5bc960; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_scriptprogress
    ADD CONSTRAINT step_id_refs_id_6e5bc960 FOREIGN KEY (step_id) REFERENCES script_scriptstep(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: submission_id_refs_id_53bbcf01; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformsubmissionvalue
    ADD CONSTRAINT submission_id_refs_id_53bbcf01 FOREIGN KEY (submission_id) REFERENCES rapidsms_xforms_xformsubmission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tree_parent_id_refs_id_47ca058b; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY locations_location
    ADD CONSTRAINT tree_parent_id_refs_id_47ca058b FOREIGN KEY (tree_parent_id) REFERENCES locations_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: unregister_blacklist_connection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY unregister_blacklist
    ADD CONSTRAINT unregister_blacklist_connection_id_fkey FOREIGN KEY (connection_id) REFERENCES rapidsms_connection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_121c1766; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY contact_masstext
    ADD CONSTRAINT user_id_refs_id_121c1766 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_13d582a3; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY uganda_common_access
    ADD CONSTRAINT user_id_refs_id_13d582a3 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_34b0616d; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY generic_dashboard
    ADD CONSTRAINT user_id_refs_id_34b0616d FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_474ea74c; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_poll
    ADD CONSTRAINT user_id_refs_id_474ea74c FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_56bfdb62; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY tastypie_apikey
    ADD CONSTRAINT user_id_refs_id_56bfdb62 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_5eadb3f8; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY script_email_recipients
    ADD CONSTRAINT user_id_refs_id_5eadb3f8 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_68dccb6f; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_settings
    ADD CONSTRAINT user_id_refs_id_68dccb6f FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_7871a68a; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY poll_responsecategory
    ADD CONSTRAINT user_id_refs_id_7871a68a FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_7ceef80f; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT user_id_refs_id_7ceef80f FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_7f5857ff; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ureport_permit
    ADD CONSTRAINT user_id_refs_id_7f5857ff FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_dfbab7d; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT user_id_refs_id_dfbab7d FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: value_ptr_id_refs_id_154144ab; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformsubmissionvalue
    ADD CONSTRAINT value_ptr_id_refs_id_154144ab FOREIGN KEY (value_ptr_id) REFERENCES eav_value(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: worker_id_refs_id_4e3453a; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT worker_id_refs_id_4e3453a FOREIGN KEY (worker_id) REFERENCES djcelery_workerstate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: xform_id_refs_id_1b02cdc; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xform_restrict_to
    ADD CONSTRAINT xform_id_refs_id_1b02cdc FOREIGN KEY (xform_id) REFERENCES rapidsms_xforms_xform(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: xform_id_refs_id_23123321; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformsubmission
    ADD CONSTRAINT xform_id_refs_id_23123321 FOREIGN KEY (xform_id) REFERENCES rapidsms_xforms_xform(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: xform_id_refs_id_67f87855; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformlist
    ADD CONSTRAINT xform_id_refs_id_67f87855 FOREIGN KEY (xform_id) REFERENCES rapidsms_xforms_xform(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: xform_id_refs_id_bd4efe; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformfield
    ADD CONSTRAINT xform_id_refs_id_bd4efe FOREIGN KEY (xform_id) REFERENCES rapidsms_xforms_xform(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: xformreportsubmission_id_refs_id_ab9c201; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformreportsubmission_submissions
    ADD CONSTRAINT xformreportsubmission_id_refs_id_ab9c201 FOREIGN KEY (xformreportsubmission_id) REFERENCES rapidsms_xforms_xformreportsubmission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: xformsubmission_id_refs_id_35351faa; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY ussd_session_submissions
    ADD CONSTRAINT xformsubmission_id_refs_id_35351faa FOREIGN KEY (xformsubmission_id) REFERENCES rapidsms_xforms_xformsubmission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: xformsubmission_id_refs_id_5d83e055; Type: FK CONSTRAINT; Schema: public; Owner: helpdeskadmin
--

ALTER TABLE ONLY rapidsms_xforms_xformreportsubmission_submissions
    ADD CONSTRAINT xformsubmission_id_refs_id_5d83e055 FOREIGN KEY (xformsubmission_id) REFERENCES rapidsms_xforms_xformsubmission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

