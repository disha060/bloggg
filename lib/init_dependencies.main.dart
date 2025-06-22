part of 'init_dependencies.dart';


final serviceLocator =GetIt.instance;
Future<void> initDependencies() async{
  _initAuth();
  _initBlog();
  final supabase =await Supabase.initialize(url: AppSecrets.supabaseUrl,anonKey:AppSecrets.supabaseAnnonKey );
  Hive.defaultDirectory= (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(()=> supabase.client);

  serviceLocator.registerLazySingleton(()=>Hive.box(name :'blogs'));

  serviceLocator.registerFactory(()=> InternetConnection());
  //core
  serviceLocator.registerLazySingleton(()=>AppUserCubit());

  serviceLocator.registerFactory<ConnectionChecker>(()=> ConnectionCheckerImpl(serviceLocator(),),);

}
void _initAuth(){
  //data sorce
  serviceLocator..registerFactory<AuthRemoteDataSource>(()=>AuthRemoteDataSourceImpl(serviceLocator(),),)

  //repository
    ..registerFactory<AuthRepository>(
          () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )


  //usecases
    ..registerFactory(()=> UserSignUp(serviceLocator(),))

    ..registerFactory(()=> UserLogin(serviceLocator(),))

    ..registerFactory(()=>CurrentUser(serviceLocator()))

  //bloc
    ..registerLazySingleton(()=> AuthBloc(userSignUp: serviceLocator(), userLogin: serviceLocator(), currentUser: serviceLocator(), appUserCubit: serviceLocator()));
}

void _initBlog() {
  //Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
            () =>
            BlogRemoteDataSourceImpl(
              serviceLocator(),
            )
    )
    ..registerFactory<BlogLocalDataSource>(()=> BlogLocalDataSourceImpl(serviceLocator(), ))



//Usecases
    ..registerFactory(
          () =>
          UploadBlog(
            serviceLocator(),
          ),
    )
    ..registerFactory(() => GetAllBlogs(serviceLocator(),))

    ..registerFactory(()=> EditBlog(serviceLocator(),))
    ..registerFactory(()=> DeleteBlog(serviceLocator()))
  //Bloc
    ..registerLazySingleton(
            () =>
            BlogBloc(
              uploadBlog: serviceLocator(),
              getAllBlogs: serviceLocator(),
              editBlog: serviceLocator(),
              deleteBlog: serviceLocator(),
            )
    )

    ..registerFactory<BlogRepository>(
          () =>
          BlogRepositoryImpl(
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            //serviceLocator(),
          ),
    );
}