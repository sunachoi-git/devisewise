create table if not exists devices (
  id bigint generated always as identity primary key,
  device_name text not null unique,
  manufacturer text not null,
  category text not null,
  price_gbp numeric,
  price_source text,
  price_confirmed boolean,
  evidence_summary text,
  evidence_source text,
  side_effects text,
  side_effect_rate numeric,
  demographic_note text,
  recall_status text,
  created_at timestamptz default now()
);

-- Clear out any existing fake rows before loading real ones
delete from devices;

insert into devices
  (device_name, manufacturer, category, price_gbp, price_source, price_confirmed,
   evidence_summary, evidence_source, side_effects, side_effect_rate,
   demographic_note, recall_status)
values
  (
    'Profemur Cobalt Chrome Modular Neck Hip Stem',
    'MicroPort Orthopedics (formerly Wright Medical)',
    'Orthopaedic Implant',
    14500,
    'Private self-pay hip replacement package average, PHIN 2025/26 (no public NHS device-level tariff exists)',
    false,
    'MHRA investigation (DSI/2025/005, published Sept 2025) found increased rates of wear, corrosion, fracture, and revision surgery in cobalt chrome modular neck components compared to alternative hip designs from the same manufacturer.',
    'MHRA DSI/2025/005',
    'Metal wear/corrosion, soft tissue reaction, component fracture, revision surgery',
    0.6,
    'Approximately 2,000 UK patients implanted 2009-Jan 2025; risk reported as 6 in 1,000 patients vs fewer than 1 in 10,000 for alternative hip designs',
    'Active MHRA Device Safety Information — affected patients being recalled for clinical review'
  ),
  (
    'Allurion Gastric Balloon',
    'Allurion Technologies',
    'Bariatric / Weight-loss Device',
    3000,
    'Manufacturer/clinic list price range, not NHS-funded (self-pay weight-loss procedure)',
    false,
    'MHRA updated safety information (DSI/2026/004, FSN-01-2026, May 2026) following UK reports of the swallowable balloon failing to pass through the digestive tract as designed.',
    'MHRA DSI/2026/004',
    'Gastric outlet obstruction, small bowel obstruction, gastric perforation',
    0.34,
    'MHRA recorded 8 UK reports of perforation/small bowel obstruction and 13 UK reports of gastric outlet obstruction; manufacturer reports ~3.95% mild side effects, ~0.34% serious adverse events overall',
    'Active MHRA Device Safety Information — updated patient information and monitoring required'
  ),
  (
    'M6-C Artificial Cervical Disc',
    'Orthofix',
    'Orthopaedic Implant (spinal)',
    8000,
    'Estimated from comparable spinal implant procedure packages — no public NHS device-level price found',
    false,
    'MHRA device safety information (DSI/2026/001, Jan 2026) raised concerns about osteolysis risk; manufacturer warnings were updated internationally in 2020 but a UK Field Safety Notice was not issued until August 2025, after which the device was withdrawn from the UK market.',
    'MHRA DSI/2026/001',
    'Osteolysis (bone loss around implant), device failure requiring revision',
    null,
    'Literature indicates revision surgery typically required 5-8 years post-implant; British Association of Spinal Surgeons recommends minimum 10 years active monitoring',
    'Withdrawn from UK market (Aug 2025) — long-term monitoring mandated for existing patients'
  );
