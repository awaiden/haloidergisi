import { AccountModule } from "./account/account.module";
import { AnalyticsModule } from "./analytics/analytics.module";
import { AuthGoogleModule } from "./auth-google/auth-google.module";
import { AuthModule } from "./auth/auth.module";
import { CategoriesModule } from "./categories/categories.module";
import { CrewsModule } from "./crews/crews.module";
import { FilesModule } from "./files/files.module";
import { MessagesModule } from "./messages/messages.module";
import { PostsModule } from "./posts/posts.module";
import { ProfileModule } from "./profile/profile.module";
import { UsersModule } from "./users/users.module";

const modules = {
  AccountModule,
  AnalyticsModule,
  AuthModule,
  AuthGoogleModule,
  MessagesModule,
  CategoriesModule,
  CrewsModule,
  FilesModule,
  PostsModule,
  ProfileModule,
  UsersModule,
};

export default Object.values(modules);
