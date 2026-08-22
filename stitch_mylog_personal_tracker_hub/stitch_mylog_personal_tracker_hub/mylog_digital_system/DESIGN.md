---
name: MyLog Digital System
colors:
  surface: '#f7f9fb'
  surface-dim: '#d8dadc'
  surface-bright: '#f7f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f4f6'
  surface-container: '#eceef0'
  surface-container-high: '#e6e8ea'
  surface-container-highest: '#e0e3e5'
  on-surface: '#191c1e'
  on-surface-variant: '#464555'
  inverse-surface: '#2d3133'
  inverse-on-surface: '#eff1f3'
  outline: '#777587'
  outline-variant: '#c7c4d8'
  surface-tint: '#4d44e3'
  primary: '#3525cd'
  on-primary: '#ffffff'
  primary-container: '#4f46e5'
  on-primary-container: '#dad7ff'
  inverse-primary: '#c3c0ff'
  secondary: '#4648d4'
  on-secondary: '#ffffff'
  secondary-container: '#6063ee'
  on-secondary-container: '#fffbff'
  tertiary: '#7e3000'
  on-tertiary: '#ffffff'
  tertiary-container: '#a44100'
  on-tertiary-container: '#ffd2be'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2dfff'
  primary-fixed-dim: '#c3c0ff'
  on-primary-fixed: '#0f0069'
  on-primary-fixed-variant: '#3323cc'
  secondary-fixed: '#e1e0ff'
  secondary-fixed-dim: '#c0c1ff'
  on-secondary-fixed: '#07006c'
  on-secondary-fixed-variant: '#2f2ebe'
  tertiary-fixed: '#ffdbcc'
  tertiary-fixed-dim: '#ffb695'
  on-tertiary-fixed: '#351000'
  on-tertiary-fixed-variant: '#7b2f00'
  background: '#f7f9fb'
  on-background: '#191c1e'
  surface-variant: '#e0e3e5'
typography:
  display:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  container-padding: 24px
  stack-gap: 16px
  group-gap: 32px
  gutter: 16px
---

## Brand & Style
The design system is built on the principles of **high-utility minimalism**. It targets individuals seeking mental clarity through tracking, emphasizing an interface that recedes to prioritize user data. The aesthetic is strictly flat, eschewing gradients and shadows in favor of a "Paper & Ink" digital philosophy. 

The emotional response should be one of calm, organization, and effortless capture. By utilizing a restrained color palette and generous white space, the UI reduces cognitive load, making the act of logging daily activities feel like a moment of reflection rather than a chore.

## Colors
The palette is anchored by **Indigo** as the sole driver of action and focus. 
- **Primary Indigo (#4F46E5):** Reserved for primary actions, active states, and critical progress indicators.
- **Surface Neutrals:** A range of very light cool greys (Slate 50 to 100) are used to define content areas without the need for heavy borders or shadows.
- **Typography:** Deep charcoal is used for high-contrast readability against the white background, while secondary text uses a softer slate to denote metadata and labels.

## Typography
The system utilizes **Inter** for its exceptional legibility and neutral, systematic tone. 
- **Hierarchy:** Importance is conveyed through weight shifts (Bold for headlines, Regular for body) rather than size extremes. 
- **Tracking:** Tighten letter-spacing on larger display type for a premium, "tucked" feel. Increase tracking on uppercase labels to ensure legibility at small scales.
- **Rhythm:** A strict baseline grid should be maintained to ensure vertical rhythm across dense logging views.

## Layout & Spacing
This design system employs a **Fluid-Inset Grid**. Content is housed within a central container that scales with the viewport, but internal spacing remains generous and fixed to an 8px base unit.

- **Mobile:** 20px side margins with a single-column vertical stack.
- **Desktop/Tablet:** Max-width content container of 1024px. Use multi-column layouts for dashboards where cards span 4 or 6 columns of a 12-column grid.
- **Whitespace:** Use "generous breathing room" (32px+) between distinct functional groups to replace the need for divider lines.

## Elevation & Depth
Depth is created through **Tonal Layering** rather than shadows. 
- **Level 0 (Base):** Pure White (#FFFFFF).
- **Level 1 (Cards/Containers):** Light Slate (#F8FAFC).
- **Level 2 (In-app Overlays/Modals):** High-contrast White with a 1px Slate-200 border to define edges.
- **Interaction:** On tap or hover, elements should shift in background color (e.g., from Slate-50 to Slate-100) to provide tactile feedback without changing elevation.

## Shapes
The shape language is defined by large, friendly radii that soften the technical nature of a tracking app.
- **Cards:** Use `rounded-xl` (1.5rem) to create a soft, approachable container for data points.
- **Interactive Elements:** Buttons and input fields use `rounded-lg` (1rem).
- **Persistent Elements:** Bottom navigation and pill-tabs use a fully circular "Pill" radius for maximum distinction from content cards.

## Components
- **Flat Buttons:** No shadows or gradients. The primary button is a solid Indigo block with white text. Secondary buttons use a light indigo tint background with indigo text.
- **Pill-Style Tabs:** A container with a light grey background; the active tab is a white "chip" that appears to slide behind the text.
- **Rounded Cards:** Large radius cards with no border. Use subtle background color shifts to separate different log entries.
- **Bottom Navigation:** A fixed bar with a white background and a subtle 1px top stroke. Icons use Indigo for active states and Slate-400 for inactive.
- **Input Fields:** Large, padded fields with a light grey background. No borders unless focused; on focus, apply a 2px Indigo stroke.
- **Status Chips:** Small, pill-shaped indicators using low-saturation background tints (e.g., pale green for "completed") to keep the UI quiet.