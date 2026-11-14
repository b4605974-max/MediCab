---
name: MediCab Clean Care
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#3d4a42'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#6d7a72'
  outline-variant: '#bccac0'
  surface-tint: '#006c4a'
  primary: '#006948'
  on-primary: '#ffffff'
  primary-container: '#00855d'
  on-primary-container: '#f5fff7'
  inverse-primary: '#68dba9'
  secondary: '#416656'
  on-secondary: '#ffffff'
  secondary-container: '#c3ecd7'
  on-secondary-container: '#476c5b'
  tertiary: '#825100'
  on-tertiary: '#ffffff'
  tertiary-container: '#a36700'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#85f8c4'
  primary-fixed-dim: '#68dba9'
  on-primary-fixed: '#002114'
  on-primary-fixed-variant: '#005137'
  secondary-fixed: '#c3ecd7'
  secondary-fixed-dim: '#a8cfbc'
  on-secondary-fixed: '#002115'
  on-secondary-fixed-variant: '#294e3f'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 34px
    fontWeight: '700'
    lineHeight: 42px
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-sm: 0.75rem
  gutter-lg: 1.5rem
  margin: 1rem
  margin-md: 1.25rem
  margin-lg: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system is tailored for smart home healthcare, physical medicine cabinet companion management, and daily wellness tracking. It serves everyday consumers, caregivers, multi-member households, and chronic condition patients managing complex medication regimens. 

The emotional signature balances sterile medical confidence with warm domestic sanctuary. The UI must evoke:
- **Quiet Reassurance & Safety:** Eliminating visual panic around pill schedules and expiry alerts.
- **Clarity & Hygiene:** Crisp surfaces, airy breathing room, and soft surgical greens that signal health, vitality, and clinical order.
- **Physical Familiarity:** Subtle digital translations of physical medicine cabinet shelves, acrylic pill organizers, and tactile pharmacy containers.

The visual direction combines **Minimalist Domestic Healthcare** with **Soft Tactile Glassmorphism**. Surfaces utilize frosted acrylic translucency over clean slate backgrounds, complemented by generous corner radii, pill-shaped badge indicators, and calm ambient shadows that ground interactive items without clutter.

## Colors

The palette establishes an unmistakable medical wellness anchor through emerald and mint greens, balanced against clinical slate neutrals and warm contextual alert tones.

### Functional Palette Mapping
- **Primary (`#059669` / `#10B981`):** Represents healthy adherence, primary dosage confirmation buttons, completed routine states, and active cabinet shelf indicators.
- **Secondary / Tint Fill (`#D1FAE5` / `#ECFDF5`):** Used for ambient card backgrounds, selected compartment tabs, non-urgent dosage badges, and active toggle track fills.
- **Tertiary / Warning (`#F59E0B`):** Warm amber assigned strictly to "Expiring Soon" warnings (within 30 days) and upcoming refills to notify without inducing distress.
- **Critical Alert (`#EF4444` / `#F87171`):** Soft coral red reserved for expired medications, missed dosage logs, and depleted compartment stock levels.
- **Surface & Canvas:**
  - Base canvas: `#F8FAFC` (Slate 50)
  - Card & Shelf surface: `#FFFFFF` (Pure White with subtle translucent layering)
  - Raised shelf borders and dividers: `#E2E8F0` (Slate 200)
- **Text & Hierarchy:**
  - High-emphasis titles: `#0F172A` (Slate 900)
  - Secondary details & timestamps: `#475569` (Slate 600)
  - Muted helper text & unit markers: `#94A3B8` (Slate 400)

## Typography

The type system relies on **Plus Jakarta Sans** across all levels. Its balanced geometric construction and gentle, rounded letterforms project approachability while retaining high legibility for critical medical numbers, dosages, and expiry dates.

- **Dosage & Quantity Numeric Displays:** Render pill counts (`200 mg`, `2 capsules`) with semi-bold weights to guarantee immediate scanning for elderly or visually impaired users.
- **Status Badges & Schedule Pills:** Employ `label-md` and `label-sm` in all-caps or title-case with a subtle `+0.02em` tracking for clinical clarity.
- **Hierarchy Rules:** Medicine titles use `headline-sm` or `headline-md`; compartment shelf headings use `headline-lg` to create spatial structure on the screen.

## Layout & Spacing

The layout model is optimized for mobile touch targets (48px minimum tappable dimension) and uses an adaptable 4-to-6 column fluid grid for mobile and compact tablet devices.

- **Outer Margins:** Fixed 16px (`1rem`) on standard mobile viewports, expanding to 24px (`1.5rem`) on tablets.
- **Cabinet Shelf Metaphor Layout:** Medicine lists are grouped by physical compartments (e.g., "Top Shelf - Daily Vitamins", "Middle Shelf - Prescriptions", "Bottom Drawer - First Aid"). Each compartment functions as a distinct shelf block bounded by 16px internal padding and separated vertically by `space-lg` (24px).
- **Rhythm & Grid Flow:**
  - Inventory items sit in a 2-column card grid or full-width stacked shelf rows.
  - Medication cards maintain an inner padding of `space-md` (16px) with an inter-item gap of `space-sm` (8px) for list rows and `gutter` (16px) for grid tiles.

## Elevation & Depth

Visual hierarchy adopts a dual layer system: **Acrylic Shelf Depth** and **Soft Ambient Shadows**.

1. **Physical Medicine Shelf Division:**
   - Shelf backgrounds sit on `#F1F5F9` with a subtle top edge highlight (`1px solid rgba(255, 255, 255, 0.8)`) and a warm gray bottom hairline (`1px solid #E2E8F0`), creating a clean, architectural ledge.
2. **Medication & Bottle Cards:**
   - Neutral floating state uses an ultra-soft, diffused shadow: `0 4px 20px -2px rgba(15, 23, 42, 0.04), 0 2px 6px -1px rgba(15, 23, 42, 0.02)`.
   - Active/urgent alerts (e.g., missed dose or low stock) tint the shadow slightly with the alert color: `0 6px 20px -2px rgba(239, 68, 68, 0.12)`.
3. **Glassmorphism Modals & Bottom Sheets:**
   - Quick-log dose drawer and schedule confirmation sheets use frosted backdrop filters (`backdrop-filter: blur(16px); background: rgba(255, 255, 255, 0.88)`), framed by a fine border (`rgba(255, 255, 255, 0.6)`).

## Shapes

The interface embraces a friendly, hygienic organic form language using **Rounded (Level 2)** geometry:

- **Medication Cards & Shelf Compartments:** Built with `rounded-xl` (24px / 1.5rem) corners to provide a soft, welcoming feel.
- **Buttons & Interactive Controls:** Base action buttons use `rounded-lg` (16px / 1rem); dosage status chips and pill-log badges use full capsules (`rounded-full` / 9999px) mirroring the physical contours of capsules and tablets.
- **Input Fields & Search Containers:** Framed in 16px radius for seamless thumb contact and modern hand-feel.

## Components

### Buttons
- **Primary Action (Take Dose / Add Medicine):** Solid `#059669` fill with pure white typography, 48px to 54px touch height, full pill or 16px radius, and gentle emerald shadow on press.
- **Secondary Action (Snooze / Edit Compartment):** Tinted `#ECFDF5` background with `#047857` label, no border.
- **Tertiary / Destructive (Discard Expired):** Soft `#FEE2E2` tint with `#DC2626` text.

### Status Chips & Dosage Badges
- **Status Indicator Badges:** Full-pill shaped tags displaying stock level, days remaining, or time-to-intake.
  - *Normal / In Stock:* Background `#ECFDF5`, Text `#047857`, 6px solid green dot indicator.
  - *Expiring Soon (30d):* Background `#FEF3C7`, Text `#B45309`, amber alert dot.
  - *Low Stock / Expired:* Background `#FEE2E2`, Text `#B91C1C`, coral warning dot.

### Medicine Shelf Cards
- Crisp white surfaces (`#FFFFFF`) housing medicine thumbnail, dosage details (`1 Tablet with Breakfast`), compartment name (`Shelf B`), and a one-tap circular dosage log checkmark.
- Progress bar for remaining supply nested seamlessly into card footer using a slim 4px track (`#F1F5F9` track, `#10B981` fill).

### Lists & Compartment Sections
- Divided into collapsible physical tiers representing the ERD structure (`CABINET` -> `COMPARTMENT` -> `MEDICINE`).
- Header includes compartment icon (e.g., vial, blister pack, emergency kit), shelf name, and item counter badge.

### Inputs & Dosage Pickers
- Pill count steppers with prominent `+` and `–` touch pads enclosed in `#F1F5F9` capsules.
- Form inputs feature floating labels, clean 1.5px borders defaulting to `#E2E8F0`, and shifting to `#059669` upon active focus.

### Intake Confirmation Bottom Sheet
- Displays medicine image, scheduled time, intake instructions (e.g., "Take with food"), and twin actions: "Mark as Taken" (Primary Green) and "Remind in 15 Min" (Subtle Gray Tint).