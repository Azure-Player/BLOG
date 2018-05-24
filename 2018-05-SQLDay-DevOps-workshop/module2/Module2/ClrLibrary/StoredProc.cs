using System; // contains types (String / Int64 / Guid), Exception, and ArgumentException
using System.Data; // contains the CommandType, ConnectionState, SqlDbType, and ParameterDirection enums
using System.Data.SqlClient; // contains SqlConnection, SqlCommand, SqlParameter, and SqlDataReader
using System.Data.SqlTypes; // contains the Sql* types for input / output params
using System.Text; // contains StringBuilder
using Microsoft.SqlServer.Server; // contains SqlFacet(Attribute), SqlContext, (System)DataAccessKind


namespace CLRLibrary
{
    public class StoredProc
    {
        [SqlProcedure(Name ="UserAudit")]
        public static void UserAudit
            (
             SqlInt32 UserId,
             SqlString UserName,
             SqlString Email            
            )
        {
            using(SqlConnection con = new SqlConnection("context connection = true"))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "INSERT INTO dbo.UsersAudit (UserId,UserName,Email) "+
                    " SELECT @UserId,@UserName, @Email";
                cmd.Parameters.AddWithValue("@UserId", UserId);
                cmd.Parameters.AddWithValue("@UserName", UserName);
                cmd.Parameters.AddWithValue("@Email", Email);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
