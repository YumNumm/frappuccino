SELECT
  to_json(p) as profile,
  array_agg(to_json(s)) as reservations,
  array_agg(to_json(g)) as groups
FROM
  public.profiles as p
  INNER JOIN public.reservations r ON p.id = r.user_id
  INNER JOIN public.reservation_slots s ON r.slot_id = s.id
  INNER JOIN public.groups g ON s.group_id = g.id
GROUP BY
  p.id