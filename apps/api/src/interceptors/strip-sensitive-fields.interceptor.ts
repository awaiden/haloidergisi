import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from "@nestjs/common";
import { map, Observable } from "rxjs";

const SENSITIVE_FIELDS = new Set(["password"]);

/**
 * Removes sensitive columns (e.g. `User.password` hashes) from every HTTP
 * response body. User rows reach responses through many relations
 * (`author`, `user`, `users`, …), so this is enforced once, globally.
 */
@Injectable()
export class StripSensitiveFieldsInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    if (context.getType() !== "http") return next.handle();
    return next.handle().pipe(map(stripSensitiveFields));
  }
}

export function stripSensitiveFields<T>(value: T): T {
  if (Array.isArray(value)) {
    return value.map(stripSensitiveFields) as T;
  }

  if (!isPlainObject(value)) return value;

  const result: Record<string, unknown> = {};
  for (const [key, child] of Object.entries(value)) {
    if (!SENSITIVE_FIELDS.has(key)) result[key] = stripSensitiveFields(child);
  }
  return result as T;
}

function isPlainObject(value: unknown): value is Record<string, unknown> {
  if (value === null || typeof value !== "object") return false;
  const proto = Object.getPrototypeOf(value);
  return proto === Object.prototype || proto === null;
}
