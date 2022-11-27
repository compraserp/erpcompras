--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4

-- Started on 2022-11-26 19:41:30

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3155 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 232 (class 1255 OID 127535)
-- Name: func_retorna_ano_formatado(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.func_retorna_ano_formatado(valor integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin 
	return (cast(to_char(current_date, 'yyyy') as integer));
end;
$$;


ALTER FUNCTION public.func_retorna_ano_formatado(valor integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 127400)
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido (
    codpedido integer NOT NULL,
    nomefornecedor character varying(120),
    cpfcnpj character(14),
    mesanalise integer,
    datapedido date,
    tppedido character(2),
    status integer
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 127398)
-- Name: pedido_codpedido_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_codpedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pedido_codpedido_seq OWNER TO postgres;

--
-- TOC entry 3156 (class 0 OID 0)
-- Dependencies: 221
-- Name: pedido_codpedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_codpedido_seq OWNED BY public.pedido.codpedido;


--
-- TOC entry 204 (class 1259 OID 127177)
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto (
    codproduto integer NOT NULL,
    descricao character varying(120),
    codbarras character varying(13),
    custoatual numeric(10,2) DEFAULT 0.00,
    vlrvenda numeric(10,2) DEFAULT 0.00,
    dataalt date,
    datacad date,
    estoque numeric(10,2) DEFAULT 0.00
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 127175)
-- Name: produto_codproduto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produto_codproduto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produto_codproduto_seq OWNER TO postgres;

--
-- TOC entry 3157 (class 0 OID 0)
-- Dependencies: 203
-- Name: produto_codproduto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_codproduto_seq OWNED BY public.produto.codproduto;


--
-- TOC entry 208 (class 1259 OID 127200)
-- Name: produto_medias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto_medias (
    codmedia integer NOT NULL,
    codproduto integer,
    ano integer,
    mes integer,
    total numeric(10,2) DEFAULT 0.00,
    natureza character(1),
    operacao character(2)
);


ALTER TABLE public.produto_medias OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 127198)
-- Name: produto_medias_codmedia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produto_medias_codmedia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produto_medias_codmedia_seq OWNER TO postgres;

--
-- TOC entry 3158 (class 0 OID 0)
-- Dependencies: 207
-- Name: produto_medias_codmedia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_medias_codmedia_seq OWNED BY public.produto_medias.codmedia;


--
-- TOC entry 224 (class 1259 OID 127438)
-- Name: produto_pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto_pedido (
    codprodped integer NOT NULL,
    codproduto integer,
    codpedido integer,
    sugestao numeric(10,2) DEFAULT 0.00,
    qtdcomprar numeric(10,2) DEFAULT 0.00,
    gerapedido integer,
    estoqueitem numeric(10,2) DEFAULT 0.00,
    totent numeric(10,2) DEFAULT 0.00,
    totsai numeric(10,2) DEFAULT 0.00
);


ALTER TABLE public.produto_pedido OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 127436)
-- Name: produto_pedido_codprodped_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produto_pedido_codprodped_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produto_pedido_codprodped_seq OWNER TO postgres;

--
-- TOC entry 3159 (class 0 OID 0)
-- Dependencies: 223
-- Name: produto_pedido_codprodped_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_pedido_codprodped_seq OWNED BY public.produto_pedido.codprodped;


--
-- TOC entry 201 (class 1259 OID 126614)
-- Name: usuario_comprador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_comprador (
    codacesso integer NOT NULL,
    nome character varying(120),
    funcao integer,
    pwd character varying(100)
);


ALTER TABLE public.usuario_comprador OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 126612)
-- Name: usuario_comprador_codacesso_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_comprador_codacesso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_comprador_codacesso_seq OWNER TO postgres;

--
-- TOC entry 3160 (class 0 OID 0)
-- Dependencies: 200
-- Name: usuario_comprador_codacesso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_comprador_codacesso_seq OWNED BY public.usuario_comprador.codacesso;


--
-- TOC entry 231 (class 1259 OID 127536)
-- Name: vw_insere_media_entrega; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_insere_media_entrega AS
 SELECT pd.codpedido,
    pdi.codproduto,
    pd.mesanalise,
    pd.tppedido,
    pdi.qtdcomprar
   FROM (public.pedido pd
     JOIN public.produto_pedido pdi ON ((pdi.codpedido = pd.codpedido)))
  WHERE (pdi.gerapedido = 1);


ALTER TABLE public.vw_insere_media_entrega OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 127346)
-- Name: vw_list_comprador; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_list_comprador AS
 SELECT usuario_comprador.codacesso,
    usuario_comprador.nome,
        CASE usuario_comprador.funcao
            WHEN 0 THEN 'Comprador'::text
            WHEN 1 THEN 'Revisor de pedidos'::text
            WHEN 2 THEN 'Administrador'::text
            ELSE 'Não cadastrado.'::text
        END AS funcao
   FROM public.usuario_comprador
  ORDER BY usuario_comprador.nome;


ALTER TABLE public.vw_list_comprador OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 127251)
-- Name: vw_list_media_entrada; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_list_media_entrada AS
SELECT
    NULL::integer AS codmedia,
    NULL::integer AS codproduto,
    NULL::text AS mes,
    NULL::integer AS ano,
    NULL::character(2) AS operacao,
    NULL::character(1) AS natureza,
    NULL::numeric AS total;


ALTER TABLE public.vw_list_media_entrada OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 127246)
-- Name: vw_list_media_saida; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_list_media_saida AS
SELECT
    NULL::integer AS codmedia,
    NULL::integer AS codproduto,
    NULL::text AS mes,
    NULL::character(2) AS operacao,
    NULL::integer AS ano,
    NULL::character(1) AS natureza,
    NULL::numeric AS total;


ALTER TABLE public.vw_list_media_saida OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 127480)
-- Name: vw_list_pedidocab; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_list_pedidocab AS
 SELECT pedido.codpedido,
    pedido.nomefornecedor,
    pedido.cpfcnpj,
    pedido.status,
    pedido.datapedido,
    pedido.tppedido,
        CASE
            WHEN (pedido.status = 0) THEN 'Pendente de entrega'::text
            WHEN (pedido.status = 1) THEN 'Entregue'::text
            ELSE 'Sit. desconhecida'::text
        END AS status_des
   FROM public.pedido
  ORDER BY pedido.codpedido, pedido.datapedido, pedido.nomefornecedor;


ALTER TABLE public.vw_list_pedidocab OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 127472)
-- Name: vw_list_pedidos_pendentes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_list_pedidos_pendentes AS
 SELECT pedido.codpedido,
    pedido.nomefornecedor,
    pedido.datapedido,
    pedido.tppedido,
    pedido.status
   FROM public.pedido
  WHERE (pedido.status = 0)
  ORDER BY pedido.datapedido, pedido.nomefornecedor;


ALTER TABLE public.vw_list_pedidos_pendentes OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 127190)
-- Name: vw_list_produto; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_list_produto AS
 SELECT produto.codproduto,
    produto.descricao,
    produto.codbarras,
    produto.estoque,
    produto.custoatual,
    produto.vlrvenda
   FROM public.produto
  ORDER BY produto.descricao;


ALTER TABLE public.vw_list_produto OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 126618)
-- Name: vw_list_usuario_comprador; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_list_usuario_comprador AS
 SELECT usuario_comprador.codacesso,
    usuario_comprador.nome,
        CASE usuario_comprador.funcao
            WHEN 0 THEN 'Comprador'::text
            WHEN 1 THEN 'Revisor de pedidos'::text
            ELSE NULL::text
        END AS funcao
   FROM public.usuario_comprador
  WHERE (usuario_comprador.funcao <> 100)
  ORDER BY usuario_comprador.nome;


ALTER TABLE public.vw_list_usuario_comprador OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 127393)
-- Name: vw_media_entrada_por_mes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_media_entrada_por_mes AS
 WITH media_entrada AS (
         SELECT produto_medias.codproduto,
            produto_medias.ano,
            produto_medias.mes,
            produto_medias.total
           FROM public.produto_medias
          WHERE (produto_medias.natureza = 'E'::bpchar)
        )
 SELECT round(COALESCE((sum(media_entrada.total) / (count(media_entrada.ano))::numeric), NULL::numeric, (0)::numeric), 2) AS media,
    media_entrada.codproduto,
    media_entrada.mes
   FROM media_entrada
  GROUP BY media_entrada.codproduto, media_entrada.mes;


ALTER TABLE public.vw_media_entrada_por_mes OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 127388)
-- Name: vw_media_saida_por_mes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_media_saida_por_mes AS
 WITH media_saida AS (
         SELECT produto_medias.codproduto,
            produto_medias.ano,
            produto_medias.mes,
            produto_medias.total
           FROM public.produto_medias
          WHERE (produto_medias.natureza = 'S'::bpchar)
        )
 SELECT round(COALESCE((sum(media_saida.total) / (count(media_saida.ano))::numeric), NULL::numeric, (0)::numeric), 2) AS media,
    media_saida.codproduto,
    media_saida.mes
   FROM media_saida
  GROUP BY media_saida.codproduto, media_saida.mes;


ALTER TABLE public.vw_media_saida_por_mes OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 127354)
-- Name: vw_pesquisa_produto; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_pesquisa_produto AS
 SELECT produto.codproduto,
    produto.descricao,
    produto.estoque
   FROM public.produto
  ORDER BY produto.descricao;


ALTER TABLE public.vw_pesquisa_produto OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 127264)
-- Name: vw_produtos_sem_compra; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_produtos_sem_compra AS
 SELECT ((produto.codproduto || ' - '::text) || (produto.descricao)::text) AS produto,
    produto.estoque,
    produto.custoatual,
    produto.vlrvenda
   FROM public.produto
  WHERE (NOT (produto.codproduto IN ( SELECT DISTINCT produto_medias.codproduto
           FROM public.produto_medias
          WHERE ((produto_medias.natureza = 'E'::bpchar) AND (produto_medias.operacao = 'PC'::bpchar)))));


ALTER TABLE public.vw_produtos_sem_compra OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 127260)
-- Name: vw_produtos_sem_saida; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_produtos_sem_saida AS
 SELECT ((produto.codproduto || ' - '::text) || (produto.descricao)::text) AS produto,
    produto.estoque,
    produto.custoatual,
    produto.vlrvenda
   FROM public.produto
  WHERE (NOT (produto.codproduto IN ( SELECT DISTINCT produto_medias.codproduto
           FROM public.produto_medias
          WHERE (produto_medias.natureza = 'S'::bpchar))));


ALTER TABLE public.vw_produtos_sem_saida OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 127530)
-- Name: vw_rel_pedido; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_rel_pedido AS
 SELECT pd.codpedido,
    pd.nomefornecedor,
        CASE pd.status
            WHEN 0 THEN 'Pedido pendente'::text
            WHEN 1 THEN 'Pedido entregue'::text
            ELSE ''::text
        END AS status,
    pd.cpfcnpj,
    pd.datapedido,
    ((pdi.codproduto || ' - '::text) || (pr.descricao)::text) AS produto,
    pr.codbarras,
    pdi.qtdcomprar,
    pr.custoatual,
    (pr.custoatual * pdi.qtdcomprar) AS custo_total
   FROM ((public.pedido pd
     JOIN public.produto_pedido pdi ON ((pdi.codpedido = pd.codpedido)))
     JOIN public.produto pr ON ((pr.codproduto = pdi.codproduto)))
  WHERE (pdi.gerapedido = 1)
  ORDER BY pr.descricao;


ALTER TABLE public.vw_rel_pedido OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 127295)
-- Name: vw_resumo_entradas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_resumo_entradas AS
 SELECT produto_medias.codproduto,
    produto_medias.ano,
    produto_medias.mes,
        CASE
            WHEN (produto_medias.mes = 0) THEN 'Jan'::text
            WHEN (produto_medias.mes = 1) THEN 'Fev'::text
            WHEN (produto_medias.mes = 2) THEN 'Mar'::text
            WHEN (produto_medias.mes = 3) THEN 'Abr'::text
            WHEN (produto_medias.mes = 4) THEN 'Mai'::text
            WHEN (produto_medias.mes = 5) THEN 'Jun'::text
            WHEN (produto_medias.mes = 6) THEN 'Jul'::text
            WHEN (produto_medias.mes = 7) THEN 'Ago'::text
            WHEN (produto_medias.mes = 8) THEN 'Set'::text
            WHEN (produto_medias.mes = 9) THEN 'Out'::text
            WHEN (produto_medias.mes = 10) THEN 'Nov'::text
            WHEN (produto_medias.mes = 11) THEN 'Dez'::text
            ELSE ' - '::text
        END AS mes_form,
    sum(produto_medias.total) AS total
   FROM public.produto_medias
  WHERE (produto_medias.natureza = 'E'::bpchar)
  GROUP BY produto_medias.codproduto, produto_medias.ano, produto_medias.mes
  ORDER BY produto_medias.ano, produto_medias.mes, (sum(produto_medias.total));


ALTER TABLE public.vw_resumo_entradas OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 127268)
-- Name: vw_resumo_produto; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_resumo_produto AS
 SELECT produto.codproduto,
    ((produto.codproduto || ' - '::text) || (produto.descricao)::text) AS produto,
    produto.codbarras,
    produto.custoatual,
    produto.vlrvenda,
    produto.estoque
   FROM public.produto
  ORDER BY produto.descricao;


ALTER TABLE public.vw_resumo_produto OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 127290)
-- Name: vw_resumo_saidas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_resumo_saidas AS
 SELECT produto_medias.codproduto,
    produto_medias.ano,
    produto_medias.mes,
        CASE
            WHEN (produto_medias.mes = 0) THEN 'Jan'::text
            WHEN (produto_medias.mes = 1) THEN 'Fev'::text
            WHEN (produto_medias.mes = 2) THEN 'Mar'::text
            WHEN (produto_medias.mes = 3) THEN 'Abr'::text
            WHEN (produto_medias.mes = 4) THEN 'Mai'::text
            WHEN (produto_medias.mes = 5) THEN 'Jun'::text
            WHEN (produto_medias.mes = 6) THEN 'Jul'::text
            WHEN (produto_medias.mes = 7) THEN 'Ago'::text
            WHEN (produto_medias.mes = 8) THEN 'Set'::text
            WHEN (produto_medias.mes = 9) THEN 'Out'::text
            WHEN (produto_medias.mes = 10) THEN 'Nov'::text
            WHEN (produto_medias.mes = 11) THEN 'Dez'::text
            ELSE ' - '::text
        END AS mes_form,
    sum(produto_medias.total) AS total
   FROM public.produto_medias
  WHERE (produto_medias.natureza = 'S'::bpchar)
  GROUP BY produto_medias.codproduto, produto_medias.ano, produto_medias.mes
  ORDER BY produto_medias.ano, produto_medias.mes, (sum(produto_medias.total));


ALTER TABLE public.vw_resumo_saidas OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 127496)
-- Name: vw_seleciona_produtos_analise; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_seleciona_produtos_analise AS
 WITH produto_analise AS (
         SELECT pd.codproduto,
            pd.descricao,
            pd.codbarras,
            pd.custoatual,
            pd.vlrvenda,
            pd.estoque,
            pm.natureza,
            sum(0) AS total_entrada,
            sum(pm.total) AS total_saida
           FROM (public.produto pd
             LEFT JOIN public.produto_medias pm ON ((pm.codproduto = pd.codproduto)))
          WHERE (pm.natureza = 'S'::bpchar)
          GROUP BY pd.codproduto, pd.descricao, pd.codbarras, pd.custoatual, pd.vlrvenda, pd.estoque, pm.natureza
        UNION ALL
         SELECT pd.codproduto,
            pd.descricao,
            pd.codbarras,
            pd.custoatual,
            pd.vlrvenda,
            pd.estoque,
            pm.natureza,
            sum(pm.total) AS total_entrada,
            sum(0) AS total_saida
           FROM (public.produto pd
             LEFT JOIN public.produto_medias pm ON ((pm.codproduto = pd.codproduto)))
          WHERE (pm.natureza = 'E'::bpchar)
          GROUP BY pd.codproduto, pd.descricao, pd.codbarras, pd.custoatual, pd.vlrvenda, pd.estoque, pm.natureza
        UNION ALL
         SELECT produto.codproduto,
            produto.descricao,
            produto.codbarras,
            produto.custoatual,
            produto.vlrvenda,
            produto.estoque,
            'N'::bpchar AS natureza,
            0 AS total_entrada,
            0 AS total_saida
           FROM public.produto
        )
 SELECT produto_analise.codproduto,
    produto_analise.descricao,
    produto_analise.codbarras,
    produto_analise.custoatual,
    produto_analise.vlrvenda,
    produto_analise.estoque,
    sum(produto_analise.total_entrada) AS entradas,
    sum(produto_analise.total_saida) AS saidas
   FROM produto_analise
  GROUP BY produto_analise.codproduto, produto_analise.descricao, produto_analise.codbarras, produto_analise.custoatual, produto_analise.vlrvenda, produto_analise.estoque;


ALTER TABLE public.vw_seleciona_produtos_analise OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 127350)
-- Name: vw_select_comprador; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_select_comprador AS
 SELECT usuario_comprador.codacesso,
    usuario_comprador.nome,
    usuario_comprador.funcao
   FROM public.usuario_comprador;


ALTER TABLE public.vw_select_comprador OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 127501)
-- Name: vw_select_pedido; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_select_pedido AS
 SELECT pedido.codpedido,
    pedido.nomefornecedor,
    pedido.cpfcnpj,
    pedido.datapedido,
    pedido.status,
    pedido.mesanalise,
        CASE pedido.tppedido
            WHEN 'PC'::bpchar THEN 0
            ELSE NULL::integer
        END AS tppedido
   FROM public.pedido;


ALTER TABLE public.vw_select_pedido OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 127194)
-- Name: vw_select_produto; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_select_produto AS
 SELECT produto.codproduto,
    produto.descricao,
    produto.codbarras,
    produto.custoatual,
    produto.vlrvenda,
    produto.dataalt,
    produto.estoque
   FROM public.produto;


ALTER TABLE public.vw_select_produto OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 127464)
-- Name: vw_select_produtos_pedido; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_select_produtos_pedido AS
 SELECT pp.codprodped,
    pp.codproduto,
    pt.descricao,
    pt.codbarras,
    pp.codpedido,
    pp.sugestao,
    pp.totent,
    pp.totsai,
    pp.qtdcomprar,
    pp.gerapedido,
    pp.estoqueitem
   FROM (public.produto_pedido pp
     JOIN public.produto pt ON ((pt.codproduto = pp.codproduto)));


ALTER TABLE public.vw_select_produtos_pedido OWNER TO postgres;

--
-- TOC entry 2970 (class 2604 OID 127403)
-- Name: pedido codpedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido ALTER COLUMN codpedido SET DEFAULT nextval('public.pedido_codpedido_seq'::regclass);


--
-- TOC entry 2964 (class 2604 OID 127180)
-- Name: produto codproduto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto ALTER COLUMN codproduto SET DEFAULT nextval('public.produto_codproduto_seq'::regclass);


--
-- TOC entry 2968 (class 2604 OID 127203)
-- Name: produto_medias codmedia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_medias ALTER COLUMN codmedia SET DEFAULT nextval('public.produto_medias_codmedia_seq'::regclass);


--
-- TOC entry 2971 (class 2604 OID 127441)
-- Name: produto_pedido codprodped; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_pedido ALTER COLUMN codprodped SET DEFAULT nextval('public.produto_pedido_codprodped_seq'::regclass);


--
-- TOC entry 2963 (class 2604 OID 126617)
-- Name: usuario_comprador codacesso; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_comprador ALTER COLUMN codacesso SET DEFAULT nextval('public.usuario_comprador_codacesso_seq'::regclass);


--
-- TOC entry 3147 (class 0 OID 127400)
-- Dependencies: 222
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido (codpedido, nomefornecedor, cpfcnpj, mesanalise, datapedido, tppedido, status) FROM stdin;
\.


--
-- TOC entry 3143 (class 0 OID 127177)
-- Dependencies: 204
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto (codproduto, descricao, codbarras, custoatual, vlrvenda, dataalt, datacad, estoque) FROM stdin;
\.


--
-- TOC entry 3145 (class 0 OID 127200)
-- Dependencies: 208
-- Data for Name: produto_medias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto_medias (codmedia, codproduto, ano, mes, total, natureza, operacao) FROM stdin;
\.


--
-- TOC entry 3149 (class 0 OID 127438)
-- Dependencies: 224
-- Data for Name: produto_pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto_pedido (codprodped, codproduto, codpedido, sugestao, qtdcomprar, gerapedido, estoqueitem, totent, totsai) FROM stdin;
\.


--
-- TOC entry 3141 (class 0 OID 126614)
-- Dependencies: 201
-- Data for Name: usuario_comprador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario_comprador (codacesso, nome, funcao, pwd) FROM stdin;
1	adm	2	449977705b5208d07a4ad68da3ff6ac5
\.


--
-- TOC entry 3161 (class 0 OID 0)
-- Dependencies: 221
-- Name: pedido_codpedido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_codpedido_seq', 1, false);


--
-- TOC entry 3162 (class 0 OID 0)
-- Dependencies: 203
-- Name: produto_codproduto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_codproduto_seq', 1, false);


--
-- TOC entry 3163 (class 0 OID 0)
-- Dependencies: 207
-- Name: produto_medias_codmedia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_medias_codmedia_seq', 1, false);


--
-- TOC entry 3164 (class 0 OID 0)
-- Dependencies: 223
-- Name: produto_pedido_codprodped_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_pedido_codprodped_seq', 1, false);


--
-- TOC entry 3165 (class 0 OID 0)
-- Dependencies: 200
-- Name: usuario_comprador_codacesso_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_comprador_codacesso_seq', 1, true);


--
-- TOC entry 2982 (class 2606 OID 127405)
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (codpedido);


--
-- TOC entry 2980 (class 2606 OID 127206)
-- Name: produto_medias produto_medias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_medias
    ADD CONSTRAINT produto_medias_pkey PRIMARY KEY (codmedia);


--
-- TOC entry 2984 (class 2606 OID 127445)
-- Name: produto_pedido produto_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_pedido
    ADD CONSTRAINT produto_pedido_pkey PRIMARY KEY (codprodped);


--
-- TOC entry 2978 (class 2606 OID 127184)
-- Name: produto produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (codproduto);


--
-- TOC entry 3121 (class 2618 OID 127249)
-- Name: vw_list_media_saida _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.vw_list_media_saida AS
 SELECT produto_medias.codmedia,
    produto_medias.codproduto,
        CASE
            WHEN (produto_medias.mes = 0) THEN 'Jan'::text
            WHEN (produto_medias.mes = 1) THEN 'Fev'::text
            WHEN (produto_medias.mes = 2) THEN 'Mar'::text
            WHEN (produto_medias.mes = 3) THEN 'Abr'::text
            WHEN (produto_medias.mes = 4) THEN 'Mai'::text
            WHEN (produto_medias.mes = 5) THEN 'Jun'::text
            WHEN (produto_medias.mes = 6) THEN 'Jul'::text
            WHEN (produto_medias.mes = 7) THEN 'Ago'::text
            WHEN (produto_medias.mes = 8) THEN 'Set'::text
            WHEN (produto_medias.mes = 9) THEN 'Out'::text
            WHEN (produto_medias.mes = 10) THEN 'Nov'::text
            WHEN (produto_medias.mes = 11) THEN 'Dez'::text
            ELSE ' - '::text
        END AS mes,
    produto_medias.operacao,
    produto_medias.ano,
    produto_medias.natureza,
    sum(produto_medias.total) AS total
   FROM public.produto_medias
  WHERE (produto_medias.natureza = 'S'::bpchar)
  GROUP BY produto_medias.codproduto, produto_medias.mes, produto_medias.ano, produto_medias.natureza, produto_medias.codmedia
  ORDER BY produto_medias.ano, produto_medias.mes, produto_medias.total;


--
-- TOC entry 3122 (class 2618 OID 127254)
-- Name: vw_list_media_entrada _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.vw_list_media_entrada AS
 SELECT produto_medias.codmedia,
    produto_medias.codproduto,
        CASE
            WHEN (produto_medias.mes = 0) THEN 'Jan'::text
            WHEN (produto_medias.mes = 1) THEN 'Fev'::text
            WHEN (produto_medias.mes = 2) THEN 'Mar'::text
            WHEN (produto_medias.mes = 3) THEN 'Abr'::text
            WHEN (produto_medias.mes = 4) THEN 'Mai'::text
            WHEN (produto_medias.mes = 5) THEN 'Jun'::text
            WHEN (produto_medias.mes = 6) THEN 'Jul'::text
            WHEN (produto_medias.mes = 7) THEN 'Ago'::text
            WHEN (produto_medias.mes = 8) THEN 'Set'::text
            WHEN (produto_medias.mes = 9) THEN 'Out'::text
            WHEN (produto_medias.mes = 10) THEN 'Nov'::text
            WHEN (produto_medias.mes = 11) THEN 'Dez'::text
            ELSE ' - '::text
        END AS mes,
    produto_medias.ano,
    produto_medias.operacao,
    produto_medias.natureza,
    sum(produto_medias.total) AS total
   FROM public.produto_medias
  WHERE (produto_medias.natureza = 'E'::bpchar)
  GROUP BY produto_medias.codproduto, produto_medias.mes, produto_medias.ano, produto_medias.natureza, produto_medias.codmedia
  ORDER BY produto_medias.ano, produto_medias.mes, produto_medias.total;


--
-- TOC entry 2987 (class 2606 OID 127451)
-- Name: produto_pedido fk_cod_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_pedido
    ADD CONSTRAINT fk_cod_pedido FOREIGN KEY (codpedido) REFERENCES public.pedido(codpedido);


--
-- TOC entry 2985 (class 2606 OID 127207)
-- Name: produto_medias fk_cod_produto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_medias
    ADD CONSTRAINT fk_cod_produto FOREIGN KEY (codproduto) REFERENCES public.produto(codproduto);


--
-- TOC entry 2986 (class 2606 OID 127446)
-- Name: produto_pedido fk_cod_produto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_pedido
    ADD CONSTRAINT fk_cod_produto FOREIGN KEY (codproduto) REFERENCES public.produto(codproduto);


-- Completed on 2022-11-26 19:41:30

--
-- PostgreSQL database dump complete
--

