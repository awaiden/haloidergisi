const BATS = [
  { top: "8%", size: 36, dur: 16, delay: 0 },
  { top: "18%", size: 28, dur: 22, delay: -6 },
  { top: "32%", size: 44, dur: 19, delay: -11 },
  { top: "46%", size: 24, dur: 25, delay: -3 },
  { top: "60%", size: 38, dur: 18, delay: -14 },
  { top: "74%", size: 30, dur: 21, delay: -8 },
  { top: "88%", size: 26, dur: 24, delay: -17 },
];

function Bat({ size }: { size: number }) {
  return (
    <svg
      width={size}
      height={size * 0.5}
      viewBox='0 0 64 32'
      fill='currentColor'
    >
      <path d='M32 8c-2 0-3 3-4 5-4-4-10-6-18-5 4 2 6 5 6 9-5-1-9 0-12 3 6 0 10 2 12 6 3-3 6-3 9 0 1-3 3-5 7-5s6 2 7 5c3-3 6-3 9 0 2-4 6-6 12-6-3-3-7-4-12-3 0-4 2-7 6-9-8-1-14 1-18 5-1-2-2-5-4-5z' />
    </svg>
  );
}

function Web({ flip }: { flip?: boolean }) {
  return (
    <svg
      width='100%'
      height='100%'
      viewBox='0 0 100 100'
      fill='none'
      stroke='currentColor'
      strokeWidth='1.2'
      className={`text-foreground/50 absolute top-16 size-52 md:size-80 ${flip ? "right-0 -scale-x-100" : "left-0"}`}
    >
      <path d='M0 0L100 0M0 0L90 40M0 0L65 65M0 0L40 90M0 0L0 100' />
      <path d='M25 0Q22 22 0 25M50 0Q42 42 0 50M75 0Q62 62 0 75M100 0Q82 82 0 100' />
    </svg>
  );
}

function Ghost() {
  return (
    <svg
      width='64'
      height='84'
      viewBox='0 0 64 84'
    >
      <path
        d='M32 2C14 2 4 16 4 34v46l9-8 7 9 6-9 6 9 7-9 9 8V34C48 16 50 2 32 2z'
        fill='#e5e7eb'
        opacity='.85'
      />
      <ellipse
        cx='21'
        cy='32'
        rx='6'
        ry='10'
        fill='#0b0618'
      />
      <ellipse
        cx='43'
        cy='32'
        rx='6'
        ry='10'
        fill='#0b0618'
      />
      <ellipse
        cx='32'
        cy='56'
        rx='8'
        ry='13'
        fill='#0b0618'
      />
    </svg>
  );
}

const SPIDERS = [
  { left: "14%", len: 90, delay: 0 },
  { left: "47%", len: 140, delay: -2 },
  { left: "83%", len: 70, delay: -4 },
];

const GHOSTS = [
  { top: "22%", dur: 34, delay: -5 },
  { top: "55%", dur: 42, delay: -20 },
];

export default function HalloweenDecor() {
  return (
    <div
      aria-hidden
      className='season-decor pointer-events-none fixed inset-0 z-[60] overflow-hidden'
    >
      <Web />
      <Web flip />
      {SPIDERS.map((sp, i) => (
        <div
          key={i}
          className='spider'
          style={
            {
              left: sp.left,
              "--len": `${sp.len}px`,
              "--delay": `${sp.delay}s`,
            } as React.CSSProperties
          }
        >
          <span className='spider-thread' />
          <span className='text-2xl'>🕷️</span>
        </div>
      ))}
      {GHOSTS.map((g, i) => (
        <div
          key={i}
          className='ghost'
          style={
            { top: g.top, "--dur": `${g.dur}s`, "--delay": `${g.delay}s` } as React.CSSProperties
          }
        >
          <Ghost />
        </div>
      ))}
      <div className='absolute bottom-2 left-3 flex items-end gap-1 text-4xl md:text-6xl'>
        <span>🎃</span>
        <span className='text-2xl md:text-4xl'>🪦</span>
      </div>
      <div className='absolute right-3 bottom-2 flex items-end gap-1 text-4xl md:text-6xl'>
        <span className='text-2xl md:text-4xl'>💀</span>
        <span>🎃</span>
      </div>
      <div className='fog' />
      {BATS.map((b, i) => (
        <div
          key={i}
          className='bat'
          style={
            { top: b.top, "--dur": `${b.dur}s`, "--delay": `${b.delay}s` } as React.CSSProperties
          }
        >
          <Bat size={b.size} />
        </div>
      ))}
    </div>
  );
}
