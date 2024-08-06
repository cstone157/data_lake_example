CREATE TABLE public.gantt_chart
(
    uid serial NOT NULL,
    "time" timestamp with time zone NOT NULL,
    target_a_find integer,
    target_a_fix integer,
    target_a_track integer,
    target_a_target integer,
    target_a_engage integer,

    target_b_find integer,
    target_b_fix integer,
    target_b_track integer,
    target_b_target integer,
    target_b_engage integer,

    target_c_find integer,
    target_c_fix integer,
    target_c_track integer,
    target_c_target integer,
    target_c_engage integer,

    PRIMARY KEY (uid)
);

ALTER TABLE IF EXISTS public.gantt_chart
    OWNER to shoc;


INSERT INTO public.gantt_chart
  ("time", 
   "target_a_find", "target_a_fix", "target_a_track", 
   "target_a_target", "target_a_engage", 
   "target_b_find", "target_b_fix", "target_b_track", 
   "target_b_target", "target_b_engage", 
   "target_c_find", "target_c_fix", "target_c_track", 
   "target_c_target", "target_c_engage")
  VALUES ('2023-10-31 09:00:00+00', 
		  0, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0),
      ('2023-10-31 09:01:00+00', 
		  1, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0),
		  ('2023-10-31 09:02:10+00', 
		  1, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0),
		  ('2023-10-31 09:03:00+00', 
		  1, 2, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0),
		  ('2023-10-31 09:04:00+00', 
		  0, 2, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0),
		  ('2023-10-31 09:05:00+00', 
		  0, 2, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0),
		  ('2023-10-31 09:10:00+00', 
		  0, 0, 3, 
		  0, 0, 
		  1, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  0, 0),
		  ('2023-10-31 09:15:00+00', 
		  0, 0, 3, 
		  0, 0, 
		  0, 0, 0, 
		  4, 0, 
		  0, 0, 0, 
		  0, 0),
		  ('2023-10-31 09:16:00+00', 
		  0, 0, 3, 
		  4, 0, 
		  0, 0, 0, 
		  4, 0, 
		  0, 0, 0, 
		  0, 0),
		  ('2023-10-31 09:20:00+00', 
		  0, 0, 0, 
		  0, 5, 
		  0, 0, 0, 
		  4, 0, 
		  0, 0, 0, 
		  0, 0),
		  ('2023-10-31 09:23:00+00', 
		  0, 0, 0, 
		  0, 0, 
		  0, 0, 0, 
		  4, 0, 
		  1, 0, 0, 
		  0, 0);

update public.gantt_chart set target_a_find = NULL where target_a_find = 0;
update public.gantt_chart set target_a_fix = NULL where target_a_fix = 0;
update public.gantt_chart set target_a_track = NULL where target_a_track = 0;
update public.gantt_chart set target_a_target = NULL where target_a_target = 0;
update public.gantt_chart set target_a_engage = NULL where target_a_engage = 0;
update public.gantt_chart set target_b_find = NULL where target_b_find = 0;
update public.gantt_chart set target_b_fix = NULL where target_b_fix = 0;
update public.gantt_chart set target_b_track = NULL where target_b_track = 0;
update public.gantt_chart set target_b_target = NULL where target_b_target = 0;
update public.gantt_chart set target_b_engage = NULL where target_b_engage = 0;
update public.gantt_chart set target_c_find = NULL where target_c_find = 0;
update public.gantt_chart set target_c_fix = NULL where target_c_fix = 0;
update public.gantt_chart set target_c_track = NULL where target_c_track = 0;
update public.gantt_chart set target_c_target = NULL where target_c_target = 0;
update public.gantt_chart set target_c_engage = NULL where target_c_engage = 0;

DROP TABLE public.gantt_chart;

CREATE TABLE public.gantt_chart
(
    uid serial NOT NULL,
    "time" timestamp with time zone NOT NULL,
    target_a_find text,
    target_a_fix text,
    target_a_track text,
    target_a_target text,
    target_a_engage text,

    target_b_find text,
    target_b_fix text,
    target_b_track text,
    target_b_target text,
    target_b_engage text,

    target_c_find text,
    target_c_fix text,
    target_c_track text,
    target_c_target text,
    target_c_engage text,

    PRIMARY KEY (uid)
);

ALTER TABLE IF EXISTS public.gantt_chart
    OWNER to shoc;
	
INSERT INTO public.gantt_chart
  ("time", 
   "target_a_find", "target_a_fix", "target_a_track", 
   "target_a_target", "target_a_engage", 
   "target_b_find", "target_b_fix", "target_b_track", 
   "target_b_target", "target_b_engage", 
   "target_c_find", "target_c_fix", "target_c_track", 
   "target_c_target", "target_c_engage")
  VALUES ('2023-10-31 09:00:00+00', 
		  NULL, NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL), 
      ('2023-10-31 09:01:00+00', 
		  1, NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL), 
		  ('2023-10-31 09:02:10+00', 
		  'Find', NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL), 
		  ('2023-10-31 09:03:00+00', 
		  'Find', 'Fix', NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL), 
		  ('2023-10-31 09:04:00+00', 
		  NULL, 'Fix', NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL), 
		  ('2023-10-31 09:05:00+00', 
		  NULL, 'Fix', NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL), 
		  ('2023-10-31 09:10:00+00', 
		  NULL, NULL, 'Track', 
		  NULL, NULL, 
		  'Find', NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL), 
		  ('2023-10-31 09:15:00+00', 
		  NULL, NULL, 'Track', 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  'Target', NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL), 
		  ('2023-10-31 09:16:00+00', 
		  NULL, NULL, 'Track', 
		  'Target', NULL, 
		  NULL, NULL, NULL, 
		  'Target', NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL), 
		  ('2023-10-31 09:20:00+00', 
		  NULL, NULL, NULL, 
		  NULL, 'Engage', 
		  NULL, NULL, NULL, 
		  'Target', NULL, 
		  NULL, NULL, NULL, 
		  NULL, NULL), 
		  ('2023-10-31 09:23:00+00', 
		  NULL, NULL, NULL, 
		  NULL, NULL, 
		  NULL, NULL, NULL, 
		  'Target', NULL, 
		  'Find', NULL, NULL, 
		  NULL, NULL);


CREATE TABLE public.gantt_source_data
(
    uid serial NOT NULL,
    target text,
	
    "find_start" timestamp with time zone,
    "find_stop" timestamp with time zone,

    "fix_start" timestamp with time zone,
    "fix_stop" timestamp with time zone,

    "track_start" timestamp with time zone,
    "track_stop" timestamp with time zone,

    "target_start" timestamp with time zone,
    "target_stop" timestamp with time zone,

    "engage_start" timestamp with time zone,
    "engage_stop" timestamp with time zone,

    PRIMARY KEY (uid)
);

ALTER TABLE IF EXISTS public.gantt_source_data
    OWNER to shoc;

insert into public.gantt_source_data
	("target", 
	 "find_start" , "find_stop",
	 "fix_start", "fix_stop", 
	 "track_start", "track_stop", 
	 "target_start", "target_stop", 
	 "engage_start", "engage_stop")
values 
	('target01',
	'2023-10-31 09:00:00+00', '2023-10-31 09:02:00+00',
	'2023-10-31 09:02:00+00', '2023-10-31 09:10:00+00',
	'2023-10-31 09:11:00+00', '2023-10-31 09:25:00+00',
	'2023-10-31 09:12:00+00', '2023-10-31 09:15:00+00',
	'2023-10-31 09:17:00+00', '2023-10-31 09:25:00+00'),
	('target02',
	'2023-10-31 09:15:00+00', '2023-10-31 09:16:00+00',
	null, null,
	null, null,
	'2023-10-31 09:16:00+00', '2023-10-31 09:20:00+00',
	'2023-10-31 09:20:00+00', '2023-10-31 09:22:00+00'),
	('target03',
	'2023-10-31 09:20:00+00', '2023-10-31 09:24:00+00',
	'2023-10-31 09:25:00+00', '2023-10-31 09:45:00+00',
	'2023-10-31 09:44:00+00', '2023-10-31 10:00:00+00',
	'2023-10-31 09:46:00+00', '2023-10-31 09:49:00+00',
	'2023-10-31 09:49:00+00', '2023-10-31 10:01:00+00'),
	('target04',
	'2023-10-31 09:30:00+00', '2023-10-31 09:35:00+00',
	null, null,
	'2023-10-31 09:35:00+00', '2023-10-31 10:00:00+00',
	'2023-10-31 09:38:00+00', '2023-10-31 09:48:00+00',
	'2023-10-31 09:49:00+00', '2023-10-31 10:00:00+00');